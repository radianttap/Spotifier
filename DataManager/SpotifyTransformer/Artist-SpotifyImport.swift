//
//  Artist-SpotifyImport.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/6/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

extension Artist: Unmarshaling {
	convenience init(object: MarshaledObject) throws {
		let id: String = try object.value(for: "id")
		let name: String = try object.value(for: "name")
		let uri: String = try object.value(for: "uri")
		self.init(id: id, name: name, uri: uri)

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
