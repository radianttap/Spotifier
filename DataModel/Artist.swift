//
//  Artist.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class Artist: NSObject {
	//	Properties

	let name: String
	let artistId: String
	let spotifyURI: String

	var popularity: Int = 0
	var followersCount: Int = 0
	var genres: [String] = []
	var webURL: URL?
	var imageURL: URL?

	//	Relationships

	var albums: [Album] = []


	//	Inits

	private override init() {
		fatalError("Use `init(id:name:)`")
	}

	init(id: String, name: String, uri: String) {
		self.artistId = id
		self.name = name
		self.spotifyURI = uri
		super.init()
	}
}
