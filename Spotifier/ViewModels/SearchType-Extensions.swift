//
//  SearchType-Extensions.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/18/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension Spotify.SearchType {
	///	User-facing name for the given SearchType.
	var title: String {
		switch self {
		case .artist:
			return NSLocalizedString("Artist", comment: "")
		case .album:
			return NSLocalizedString("Album", comment: "")
		case .track:
			return NSLocalizedString("Track", comment: "")
		case .playlist:
			return NSLocalizedString("Playlist", comment: "")
		}
	}

	///	Header string value, title of Search UI section.
	var headerTitle: String {
		switch self {
		case .artist:
			return NSLocalizedString("Artists", comment: "")
		case .album:
			return NSLocalizedString("Albums", comment: "")
		case .track:
			return NSLocalizedString("Tracks", comment: "")
		case .playlist:
			return NSLocalizedString("Playlists", comment: "")
		}
	}
}
