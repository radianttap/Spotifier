//
//  Artist.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Artist {
	//	Properties

	let name: String
	let id: String

	var popularity: Int = 0
	var genres: [String] = []
	var webURL: URL?
	var followersCount: Int = 0
	//
	var images: [Image] = []


	//	Relationships

	var albums: [Album] = []


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

extension Artist: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		self.init(id: id, name: name)

		popularity = (try? object.value(for: "popularity")) ?? 0
		webURL = try? object.value(for: "href")
		genres = (try? object.value(for: "genres")) ?? []
		followersCount = (try? object.value(for: "followers.total")) ?? 0

		if let images: [Image] = try? object.value(for: "images") {
			self.images = images
		}
	}
}
