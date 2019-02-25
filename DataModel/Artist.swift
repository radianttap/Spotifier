//
//  Artist.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Artist: NSObject {
	//	Properties

	let name: String
	let artistId: String

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

	init(id: String, name: String) {
		self.artistId = id
		self.name = name
		super.init()
	}
}

extension Artist: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		self.init(id: id, name: name)

		if let num: Int = try object.value(for: "popularity") {
			popularity = num
		}
		if let arr: [String] = try object.value(for: "genres") {
			genres = arr
		}
		if let num: Int = try object.value(for: "followers.total") {
			followersCount = num
		}

		webURL = try? object.value(for: "href")

		if let images: [Image] = try? object.value(for: "images") {
			self.imageURL = images.first?.url
		}
	}
}
