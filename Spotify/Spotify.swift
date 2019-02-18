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

	private let basePath: String = "https://api.spotify.com/v1/"

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

extension Spotify {
	enum Endpoint {
		case search(q: String, type: SearchType, market: String?, limit: Int?, offset: Int?)
	}
}
