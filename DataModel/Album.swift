//
//  Album.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Album: NSObject {
	//	Properties

	let name: String
	let albumId: String

	var webURL: URL?
	var imageURL: URL?
	var availableMarkets: Set<String> = []
	var numberOfTracks: Int = 0
	var releaseDate: Date?
	var releaseDatePrecision: Spotify.ReleaseDatePrecision?
	var albumType: Spotify.AlbumType = .album

	//	Relationships

	var artists: [Artist] = []
	var tracks: [Track] = []

	//	Inits

	private override init() {
		fatalError("Use `init(id:name:)`")
	}

	init(id: String, name: String) {
		self.albumId = id
		self.name = name
		super.init()
	}
}

extension Album: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		//	Properties

		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		self.init(id: id, name: name)

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
	}
}
