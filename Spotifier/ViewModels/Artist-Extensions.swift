//
//  Artist-Extensions.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/20/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension Artist {
	var cardContents: String {
		var parts: [String] = []

		if followersCount == 0 {
			parts.append( "No followers yet." )
		} else {
			parts.append( "\( followersCount ) followers." )
		}

		if genres.count > 0 {
			parts.append( "Genres: \( genres.joined(separator: ", ") )." )
		}

		if popularity > 0 {
			parts.append( "Recent popularity index: \( popularity )" )
		}

		return parts.joined(separator: "\n")
	}
}
