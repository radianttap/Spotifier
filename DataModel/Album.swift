//
//  Album.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class Album: NSObject {
	//	Properties

	let name: String
	let albumId: String
	let spotifyURI: String

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

	init(id: String, name: String, uri: String) {
		self.albumId = id
		self.name = name
		self.spotifyURI = uri
		super.init()
	}
}

