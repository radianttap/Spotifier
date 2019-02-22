//
//  ContentManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class ContentManager: NSObject {
	private var dataManager: DataManager

	init(dataManager: DataManager) {
		self.dataManager = dataManager

		super.init()
	}
}

extension ContentManager {
	func search(for q: String,
				onQueue queue: OperationQueue? = nil,
				callback: @escaping (String, [SearchResult], ContentError?) -> Void )
	{
		var localError: ContentError? = nil
		var localResults: [SearchResult] = []

		let group = DispatchGroup()

		for searchType in Spotify.SearchType.allCases {
			group.enter()
			search(for: q, type: searchType) {
				searchedTerm, results, contentError in

				if let contentError = contentError {
					localError = contentError
				}
				localResults.append(contentsOf: results)
				group.leave()
			}
		}

		group.notify(queue: .main) {
			OperationQueue.perform( callback(q, localResults, localError), onQueue: queue)
		}
	}

	private func search(for q: String,
						type: Spotify.SearchType,
						callback: @escaping (String, [SearchResult], ContentError?) -> Void )
	{
		dataManager.search(for: q, type: type) {
			results, dataError in

			if let dataError = dataError {
				callback(q, results, .dataError(dataError))
				return
			}

			callback(q, results, nil)
		}
	}


	func fetchAlbums(for artist: Artist,
				onQueue queue: OperationQueue? = nil,
				callback: @escaping (Artist, ContentError?) -> Void )
	{
		dataManager.fetchAlbums(for: artist) {
			albums, dataError in

			if let dataError = dataError {
				OperationQueue.perform( callback(artist, .dataError(dataError)), onQueue: queue)
				return
			}

			OperationQueue.perform({
				artist.albums = albums
				callback(artist, nil)
			}(), onQueue: queue)
		}
	}
}
