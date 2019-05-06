//
//  Track.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

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

	var album: Album!	//	track must have an Album

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
