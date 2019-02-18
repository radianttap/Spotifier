//
//  DataManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class DataManager {
	private var spotify: Spotify

	init(spotify: Spotify) {
		self.spotify = spotify
	}

	//	Local dummy cache

	private var artists: Set<Artist> = []
	private var albums: Set<Album> = []
	private var tracks: Set<Track> = []
	private var playlists: Set<Playlist> = []
}

extension DataManager {
	func search(for q: String,
				type: Spotify.SearchType,
				market: String? = nil,
				limit: Int? = nil,
				offset: Int? = nil,
				callback: @escaping ([SearchResult], DataError?) -> Void)
	{
		let path: Spotify.Endpoint = .search(q: q, type: type, market: market, limit: limit, offset: offset)
		spotify.call(path: path) {
			[unowned self] json, spotifyError in

			//	validate
			if let spotifyError = spotifyError {
				print(spotifyError)
				callback([], .spotifyError(spotifyError))
				return
			}

			guard let json = json else {
				callback([], nil)
				return
			}

			//	process and convert into model object
			let result = self.processSearchResult(json, forSearchType: type)

			//	execute callback
			callback( result.items, result.dataError)
		}
	}

	func createPlaylist(_ playlist: Playlist,
						callback: ( Playlist?, DataError? ) -> Void)
	{

	}

	func removeTracks(_ tracks: [Track],
					  from playlist: Playlist,
					  callback: ( Playlist, DataError? ) -> Void)
	{

	}
}
