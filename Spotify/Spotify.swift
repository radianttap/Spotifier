//
//  Spotify.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Avenue
import SwiftyOAuth

typealias JSON = [String: Any]


final class Spotify: NetworkSession {
	//	Configuration

	private static let basePath: String = "https://api.spotify.com/v1/"
	private static let clientID: String = "YOUR_CLIENT_ID"
	private static let clientSecret: String = "YOUR_CLIENT_SECRET"

	//	Init

	private override init(urlSessionConfiguration: URLSessionConfiguration) {
		fatalError("Not implemented, use `init()`")
	}

	init() {
		queue = {
			let oq = OperationQueue()
			oq.qualityOfService = .userInitiated
			return oq
		}()

		let urlSessionConfiguration: URLSessionConfiguration = {
			let c = URLSessionConfiguration.default
			c.allowsCellularAccess = true
			c.httpCookieAcceptPolicy = .never
			c.httpShouldSetCookies = false
			c.httpAdditionalHeaders = Spotify.commonHeaders
			c.requestCachePolicy = .reloadIgnoringLocalCacheData
			return c
		}()
		super.init(urlSessionConfiguration: urlSessionConfiguration)
	}

	//	Local stuff

	private var queue: OperationQueue


	//	OAuth2

	private lazy var oauthProvider = Provider.spotify(clientID: Spotify.clientID,
												 clientSecret: Spotify.clientSecret)

	private typealias APIRequest = (endpoint: Endpoint, callback: Callback )

	private var queuedRequests: [APIRequest] = []

	private var isFetchingToken = false {
		didSet {
			if isFetchingToken { return }
			processQueuedRequests()
		}
	}
}

extension Spotify {
	typealias Callback = (JSON?, SpotifyError?) -> Void

	func call(endpoint: Endpoint, callback: @escaping Callback) {
		let apiRequest = (endpoint, callback)
		oauth(apiRequest)
	}
}

private extension Spotify {
	static let commonHeaders: [String: String] = {
		return [
			"User-Agent": userAgent,
			"Accept-Charset": "utf-8",
			"Accept-Encoding": "gzip, deflate"
		]
	}()

	static var userAgent: String = {
		#if os(watchOS)
		let osName = "watchOS"
		let osVersion = ""
		let deviceVersion = "Apple Watch"
		#else
		let osName = UIDevice.current.systemName
		let osVersion = UIDevice.current.systemVersion
		let deviceVersion = UIDevice.current.model
		#endif

		let locale = Locale.current.identifier
		return "\( Bundle.appName ) \( Bundle.appVersion ) (\( Bundle.appBuild )); \( deviceVersion ); \( osName ) \( osVersion ); \( locale )"
	}()
}

extension Spotify {
	enum Endpoint {
		case search(q: String, type: SearchType, market: String?, limit: Int?, offset: Int?)
		case albums(albumId: String?)
		case artists(artistId: String?, contentType: ObjectContentType?)

		case createPlaylist(_ playlist: JSON, forUserId: String)
		case deleteTracks(_ tracks: [JSON], fromPlaylist: String)
	}
}

fileprivate extension Spotify.Endpoint {
	//	Request parts:

	fileprivate var method: NetworkHTTPMethod {
		switch self {
		case .search, .albums, .artists:
			return .GET
		case .deleteTracks:
			return .DELETE
		case .createPlaylist:
			return .POST
		}
	}

	private var headers: [String: String] {
		var h: [String: String] = [:]

		switch self {
		default:
			h["Accept"] = "application/json"
		}

		return h
	}

	private var baseURL : URL {
		guard let url = URL(string: Spotify.basePath) else { fatalError("Can't create base URL!") }
		return url
	}

	private var url: URL {
		var url = baseURL

		switch self {
		case .search:
			return url.appendingPathComponent("search")

		case .albums(let albumId):
			url = url.appendingPathComponent("albums")
			if let albumId = albumId {
				return url.appendingPathComponent(albumId)
			}
			return url

		case .artists(let artistId, let contentType):
			url = url.appendingPathComponent("artists")
			if let artistId = artistId {
				url = url.appendingPathComponent(artistId)
				if let contentType = contentType {
					url = url.appendingPathComponent(contentType.rawValue)
				}
			}
			return url

		case .createPlaylist(_, let userId):
			url = url.appendingPathComponent("users")
				.appendingPathComponent(userId)
				.appendingPathComponent("playlists")
			return url

		case .deleteTracks(_, let playlistId):
			url = url.appendingPathComponent("playlist")
				.appendingPathComponent(playlistId)
				.appendingPathComponent("tracks")
			return url
		}
	}

	private var params: JSON {
		var p: JSON = [:]

		switch self {
		case .search(let q, let type, let market, let limit, let offset):
			p["q"] = q
			p["type"] = type.rawValue
			if let market = market {
				p["market"] = market
			}
			if let limit = limit {
				p["limit"] = limit
			}
			if let offset = offset {
				p["offset"] = offset
			}

		case .albums, .artists, .deleteTracks, .createPlaylist:
			break
		}

		return p
	}

	//	Request building

	private var queryItems: [URLQueryItem]? {
		if params.count == 0 { return nil }

		var arr: [URLQueryItem] = []
		for (key, value) in params {
			let qi = URLQueryItem(name: key, value: "\( value )")
			arr.append( qi )
		}
		return arr
	}

	private var body: Data? {
		switch self {
		case .deleteTracks(let tracks, _):
			return try? JSONSerialization.data(withJSONObject: tracks)

		case .createPlaylist(let playlist, _):
			return try? JSONSerialization.data(withJSONObject: playlist)

		case .search, .albums, .artists:
			return nil
		}
	}

	var urlRequest: URLRequest {
		guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			fatalError("Invalid path-based URL")
		}
		comps.queryItems = queryItems

		guard let finalURL = comps.url else {
			fatalError("Invalid query items...(probably)")
		}

		var req = URLRequest(url: finalURL)
		req.httpMethod = method.rawValue
		req.allHTTPHeaderFields = headers
		req.httpBody = body

		return req
	}
}


private extension Spotify {
	private func oauth(_ apiRequest: APIRequest) {
		if isFetchingToken {
			queuedRequests.append(apiRequest)
			return
		}

		//	is token availalbe?
		guard let token = oauthProvider.token else {
			queuedRequests.append(apiRequest)

			fetchToken()
			return
		}

		//	is token valid?
		if token.isExpired {
			queuedRequests.append(apiRequest)

			refreshToken()
			return
		}

		execute(apiRequest)
	}

	func fetchToken() {
		if isFetchingToken { return }
		isFetchingToken = true

		oauthProvider.authorize {
			[unowned self] result in

			self.isFetchingToken = false

			switch result {
			case .success(let token):
				print(token)
			case .failure(let error):
				print(error)
			}
		}
	}

	func refreshToken() {
		fetchToken()
	}

	///	When fetching token process completes,
	///	attempt re-authorization of all received API calls
	func processQueuedRequests() {
		for apiReq in queuedRequests {
			oauth(apiReq)
		}
		queuedRequests.removeAll()
	}

	private func execute(_ apiRequest: APIRequest) {
		let endpoint = apiRequest.endpoint
		let callback = apiRequest.callback

		guard let token = oauthProvider.token, token.isValid else {
			callback(nil, .authError)
			return
		}

		var urlRequest = endpoint.urlRequest
		urlRequest.addValue("Bearer \( token.accessToken )",
			forHTTPHeaderField: "Authorization")

		let op = NetworkOperation(urlRequest: urlRequest, urlSession: urlSession) {
			payload in

			if let tsStart = payload.tsStart, let tsEnd = payload.tsEnd {
				let period = tsEnd.timeIntervalSince(tsStart) * 1000
				print("\tURL: \( urlRequest.url?.absoluteString ?? "" )\n\t⏱: \( period ) ms")
			}

			//	process the returned stuff, now
			if let error = payload.error {
				callback(nil, SpotifyError.networkError(error) )
				return
			}

			guard let httpURLResponse = payload.response else {
				callback(nil, SpotifyError.invalidResponseType)
				return
			}

			if !(200...299).contains(httpURLResponse.statusCode) {
				switch httpURLResponse.statusCode {
				default:
					callback(nil, SpotifyError.httpError(httpURLResponse))
				}
				return
			}

			guard let data = payload.data else {
				if endpoint.method.allowsEmptyResponseData {
					callback(nil, nil)
					return
				}
				callback(nil, SpotifyError.emptyResponse)
				return
			}

			guard
				let obj = try? JSONSerialization.jsonObject(with: data, options: []),	//.allowFragments
				let json = obj as? JSON
			else {
				//	conversion to JSON failed.
				//	convert to string, so the caller knows what‘s actually returned
				let str = String(data: data, encoding: .utf8)
				callback(nil, SpotifyError.unexpectedResponse(httpURLResponse, str))
				return
			}

			callback(json, nil)
		}

		queue.addOperation(op)
	}
}
