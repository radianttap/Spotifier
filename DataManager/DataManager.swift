//
//  DataManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class DataManager {
	private var spotify: Spotify

	init(spotify: Spotify) {
		self.spotify = spotify
	}

	//	Local dummy cache

	private var artists: Set<Artist> = []
	private var albums: Set<Album> = []
	private var tracks: Set<Track> = []
	private var playlists: Set<Playlist> = []
}

