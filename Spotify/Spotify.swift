//
//  Spotify.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class Spotify {

	private let basePath: String = "https://api.spotify.com/v1/"
}

extension Spotify {
	typealias JSON = [String: Any]
	typealias Callback = (JSON?, SpotifyError?) -> Void

	func call(path: Endpoint, callback: @escaping Callback) {

	}
}

extension Spotify {
	enum Endpoint {
		case search(q: String, type: SearchType, market: String?, limit: Int?, offset: Int?)
	}
}