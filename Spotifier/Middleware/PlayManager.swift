//
//  PlayManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

final class PlayManager {
	private let playlist: Playlist

	init() {
		self.playlist = Playlist()
	}

	private(set) var currentTrack: Track?
}

extension PlayManager {
	func queueTrack(_ track: Track,
					onQueue queue: OperationQueue? = nil,
					callback: @escaping (Playlist?, PlayError?) -> Void )
	{
		if playlist.tracks.contains(track) {
			OperationQueue.perform( callback(self.playlist, .trackAlreadyAdded), onQueue: queue)
			return
		}

		playlist.tracks.append(track)
		OperationQueue.perform( callback(self.playlist, nil), onQueue: queue)
	}

	func playTrack(_ track: Track) {
		if let index = playlist.tracks.firstIndex(of: track) {
			if index == 0 { return }
			let t = playlist.tracks.remove(at: index)
			playlist.tracks.insert(t, at: 0)

			play(track: t)
			return
		}

		playlist.tracks.insert(track, at: 0)
		play(track: track)
	}

	func removeTrack(_ track: Track) {
		guard let index = playlist.tracks.firstIndex(of: track) else { return }

		playlist.tracks.remove(at: index)
	}
}


extension PlayManager {
	func play(track: Track? = nil) {
		guard let t = track ?? playlist.tracks.first else { return }

		currentTrack = t
	}

	func pause() {

	}

	func stop() {
		currentTrack = nil
	}

	func next() {
		guard let currentTrack = currentTrack else {
			play(track: playlist.tracks.first)
			return
		}

		guard
			let index = playlist.tracks.firstIndex(of: currentTrack),
			index < playlist.tracks.count - 1
		else { return }

		let t = playlist.tracks[index + 1]
		play(track: t)
	}

	func previous() {
		guard let currentTrack = currentTrack else {
			return
		}

		guard
			let index = playlist.tracks.firstIndex(of: currentTrack),
			index > 0
		else { return }

		let t = playlist.tracks[index - 1]
		play(track: t)
	}
}
