//
//  Track.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Track: NSObject {
	var trackId: String
	var name: String
	var durationInMilliseconds: TimeInterval
	var trackNumber: Int
	let spotifyURI: String

	var discNumber: Int = 1
	var isExplicit = false
	var webURL: URL?			//	href
	var popularity: Int = 0

	var availableMarkets: Set<String> = []
	var isPlayable = true		//	related to linkedFromTrack and TrackRestriction
	var previewAudioURL: URL?

	//	Relationships

//	var linkedFromTrack: Track?
//	var restrictions: [TrackRestriction] = []

	weak var album: Album!	//	track must have an Album

	var artists: [Artist] = []


	//	Inits

	private override init() {
		fatalError("Use `init(id:name:)`")
	}

	init(id: String, name: String, duration: TimeInterval, trackNumber: Int, uri: String) {
		self.trackId = id
		self.name = name
		self.durationInMilliseconds = duration
		self.trackNumber = trackNumber
		self.spotifyURI = uri
		super.init()
	}
}

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

		//	Relationships

		artists = try object.value(for: "artists")
	}
}
