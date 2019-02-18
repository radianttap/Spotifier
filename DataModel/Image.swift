//
//  Image.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 11/23/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit
import Marshal

struct Image {
	let width: Int
	let height: Int
	let url: URL
}

extension Image: Unmarshaling {
	init(object: MarshaledObject) throws {
		width = try object.value(for: "width")
		height = try object.value(for: "height")
		url = try object.value(for: "url")
	}
}
