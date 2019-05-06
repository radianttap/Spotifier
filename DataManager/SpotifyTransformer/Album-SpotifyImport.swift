//
//  Album-SpotifyImport.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/6/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

extension Album: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		//	Properties

		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		let uri: String = try object.value(for: "uri")
		self.init(id: id, name: name, uri: uri)

		numberOfTracks = (try? object.value(for: "total_tracks")) ?? 0
		webURL = try? object.value(for: "href")
		availableMarkets = (try? object.value(for: "available_markets")) ?? []

		if 	let s: String = try? object.value(for: "release_date_precision"),
			let value = Spotify.ReleaseDatePrecision(rawValue: s)
		{
			releaseDatePrecision = value
		}
		releaseDate = try? object.value(for: "release_date")

		if let images: [Image] = try? object.value(for: "images") {
			self.imageURL = images.first?.url
		}

		if 	let s: String = try? object.value(for: "album_type"),
			let value = Spotify.AlbumType(rawValue: s)
		{
			albumType = value
		}

		//	Relationships

		artists = try object.value(for: "artists")

		if let arr: [Track] = try? object.value(for: "tracks.items") {
			arr.forEach { $0.album = self }
			tracks = arr
		}
	}
}
