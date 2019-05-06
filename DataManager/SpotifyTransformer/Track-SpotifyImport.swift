//
//  Track-SpotifyImport.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/6/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

extension Track: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		//	Properties

		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		let duration: TimeInterval = try object.value(for: "duration_ms")
		let trackNumber: Int = try object.value(for: "track_number")
		let uri: String = try object.value(for: "uri")
		self.init(id: id, name: name, duration: duration, trackNumber: trackNumber, uri: uri)

		discNumber = try object.value(for: "disc_number")
		previewAudioURL = try? object.value(for: "preview_url")
		webURL = try? object.value(for: "href")
		availableMarkets = (try? object.value(for: "available_markets")) ?? []
		isExplicit = try object.value(for: "explicit")

		if let num: Int = try? object.value(for: "popularity") {
			popularity = num
		}

		//	Relationships

		if let a: Album = try? object.value(for: "album") {
			album = a
		}
		artists = try object.value(for: "artists")
	}
}
