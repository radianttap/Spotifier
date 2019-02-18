//
//  Album.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Album {
	//	Properties

	let name: String
	let id: String

	var webURL: URL?
	var images: [Image] = []
	var availableMarkets: Set<String> = []
	var numberOfTracks: Int = 0
	var releaseDate: String?

	//	Relationships

	var artists: [Artist] = []
	var tracks: [Track] = []

	//	Inits

	private override init() {
		fatalError("Use `init(id:name:)`")
	}

	init(id: String, name: String) {
		self.id = id
		self.name = name
		super.init()
	}
}

extension Album: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		self.init(id: id, name: name)

		numberOfTracks = (try? object.value(for: "total_tracks")) ?? 0
		webURL = try? object.value(for: "href")
		availableMarkets = (try? object.value(for: "available_markets")) ?? []
		releaseDate = try? object.value(for: "release_date")

		if let images: [Image] = try? object.value(for: "images") {
			self.images = images
		}
		artists = try object.value(for: "artists")
	}
}
