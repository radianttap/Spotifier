//
//  SpotifyEndpoint.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/18/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation
import Avenue

extension Spotify {
	enum Endpoint {
		case search(q: String, type: SearchType, market: String?, limit: Int?, offset: Int?)
		case albums(albumId: String?)
		case artists(artistId: String?, contentType: ObjectContentType?)

		case createPlaylist(_ name: String, forUserId: String)
		case deleteTracks(_ tracks: [JSON], fromPlaylist: String)
	}
}

extension Spotify.Endpoint {
	func urlRequest(using basePath: String) throws -> URLRequest {
		let url = self.url(using: basePath)

		guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw SpotifyError.invalidBaseURL(basePath: basePath)
		}

		comps.queryItems = queryItems(params: queryParams)

		guard let finalURL = comps.url else {
			throw SpotifyError.invalidFinalURL(url: url, queryParams: queryParams)
		}

		var req = URLRequest(url: finalURL)
		req.httpMethod = httpMethod.rawValue
		req.allHTTPHeaderFields = headers

		if let bodyParams = bodyParams {
			req.httpBody = try body(params: bodyParams)
		}

		return req
	}

	var httpMethod: NetworkHTTPMethod {
		switch self {
		case .search, .albums, .artists:
			return .GET
		case .deleteTracks:
			return .DELETE
		case .createPlaylist:
			return .POST
		}
	}
}

private extension Spotify.Endpoint {
	//	Request parts:

	var headers: [String: String] {
		var h: [String: String] = [:]

		switch self {
		default:
			h["Accept"] = "application/json"
		}

		return h
	}

	private func baseURL(using basePath: String) -> URL {
		guard let url = URL(string: basePath) else { fatalError("Can't create base URL!") }
		return url
	}

	private func url(using basePath: String) -> URL {
		var url = baseURL(using: basePath)

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



	//	Request building

	///	Builds JSON object using parameters that will be sent as query-string. (Used by `queryItems`).
	var queryParams: JSON {
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

	///	Builds JSON object of parameters that will be sent as POST body.
	var bodyParams: JSON? {
		switch self {
		case .deleteTracks(let tracks, _):
			return ["tracks": tracks]

		case .createPlaylist(let name, _):
			return ["name": name]

		case .search, .albums, .artists:
			return nil
		}
	}


	///	Builds proper, RFC-compliant query-string pairs.
	func queryItems(params: JSON) -> [URLQueryItem]? {
		if params.count == 0 { return nil }

		var arr: [URLQueryItem] = []
		for (key, value) in params {
			let qi = URLQueryItem(name: key, value: "\( value )")
			arr.append( qi )
		}
		return arr
	}

	///	Converts given JSON to Data, using JSONSerialization (its exceptions will bubble up).
	func body(params: JSON) throws -> Data {
		return try JSONSerialization.data(withJSONObject: params)
	}
}
