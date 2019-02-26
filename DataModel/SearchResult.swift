//
//  Data-Types.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/9/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

protocol SearchResult: AutoBoxable {
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

	var id: String {
		return albumId
	}

	var details: String {
		return "by \( artists.map{ $0.name }.joined(separator: ", ") )\n\( numberOfTracks ) tracks [\( formattedReleaseDate ?? "" )]"
	}
}

extension Artist: SearchResult {
	var searchType: Spotify.SearchType {
		return .artist
	}

	var id: String {
		return artistId
	}

	var details: String {
		let albumsPart: String = albums.count == 0 ? "" : "\( albums.count ) albums, "
		return "\( albumsPart )\( followersCount ) followers"
	}
}

extension Track: SearchResult {
	var searchType: Spotify.SearchType {
		return .track
	}

	var id: String {
		return trackId
	}

	var imageURL: URL? {
		return album.imageURL
	}

	var details: String {
		return formattedDetails(in: .search)
	}
}

