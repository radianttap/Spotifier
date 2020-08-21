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

	private var unrecoverableError: SpotifyError?
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



private extension Spotify {
	private func oauth(_ apiRequest: APIRequest) {
		if let unrecoverableError = unrecoverableError {
			apiRequest.callback(nil, unrecoverableError)
			return
		}

		if isFetchingToken {
			queuedRequests.append(apiRequest)
			return
		}

		//	is token available?
		guard let token = oauthProvider.token else {
			queuedRequests.append(apiRequest)

			fetchToken(apiRequest)
			return
		}

		//	is token valid?
		if token.isExpired {
			queuedRequests.append(apiRequest)

			refreshToken(apiRequest)
			return
		}

		execute(apiRequest)
	}

	private func fetchToken(_ apiRequest: APIRequest) {
		if isFetchingToken { return }
		isFetchingToken = true

		oauthProvider.authorize {
			[unowned self] result in

			switch result {
			case .success(let token):
				print(token)

			case .failure(let error):
				if error.isUnrecoverable {
					self.unrecoverableError = .authError(error)
				} else {
					let callback = apiRequest.callback
					callback(nil, .authError(error))
				}
			}

			self.isFetchingToken = false
		}
	}

	private func refreshToken(_ apiRequest: APIRequest) {
		fetchToken(apiRequest)
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
			callback(nil, .invalidAuthToken)
			return
		}



		var urlRequest: URLRequest
		do {
			urlRequest = try endpoint.urlRequest(using: Spotify.basePath)

		} catch let error as SpotifyError {
			callback(nil, error )
			return

		} catch let error {
			callback(nil, SpotifyError.requestBuildFailed(error) )
			return
		}

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
				if endpoint.allowsEmptyResponseData {
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
