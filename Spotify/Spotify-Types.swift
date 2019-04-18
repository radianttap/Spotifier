//
//  Spotify-Types.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

extension Spotify {

	enum SearchType: String, CaseIterable {
		case artist
		case album
		case track
		case playlist
	}

	enum ObjectContentType: String {
		case albums //, topTracks, relatedArtists
	}

	enum ReleaseDatePrecision: String {
		case year
		case month
		case day
	}

	enum AlbumType: String {
		case album
		case single
		case compilation
	}
}
