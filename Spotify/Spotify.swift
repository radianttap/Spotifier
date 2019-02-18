//
//  Spotify.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Avenue

typealias JSON = [String: Any]


final class Spotify: NetworkSession {
	//	Configuration

	private static let basePath: String = "https://api.spotify.com/v1/"

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


}

extension Spotify {
	typealias Callback = (JSON?, SpotifyError?) -> Void

	func call(endpoint: Endpoint, callback: @escaping Callback) {

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

	private var method: NetworkHTTPMethod {
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
