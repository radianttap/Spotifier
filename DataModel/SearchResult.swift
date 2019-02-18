//
//  Data-Types.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/9/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

protocol SearchResult {
	var searchType: Spotify.SearchType { get }
	var id: String { get }
	var name: String { get }
	var details: String { get }
	var imageURL: URL? { get }
}

extension Album: SearchResult {
	var searchType: Spotify.SearchType {
		return .album
	}

	var details: String {
		return "by \( artists.map{ $0.name }.joined(separator: ", ") ), \( tracks.count ) tracks, 2018"
	}

	var imageURL: URL? {
		return images.first?.url
	}
}

extension Artist: SearchResult {
	var searchType: Spotify.SearchType {
		return .artist
	}

	var details: String {
		return "\( albums.count ) albums, \( followersCount ) followers"
	}

	var imageURL: URL? {
		return images.first?.url
	}
}

