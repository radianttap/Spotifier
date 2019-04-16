//
//  PlayManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

final class PlayManager {
	private(set) var playlist: Playlist

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

	func playTrack(_ track: Track,
				   onQueue queue: OperationQueue? = nil,
				   callback: @escaping (Playlist?, PlayError?) -> Void )
	{
		//	if the track is already in the playlist, but it's not at the top
		if
			let index = playlist.tracks.firstIndex(of: track),
			index > 0
		{
			//	then remove it from wherever it was
			playlist.tracks.remove(at: index)
			//	and then...
		}

		//	insert this track at the top
		playlist.tracks.insert(track, at: 0)
		//	and play it
		play(track: track)

		OperationQueue.perform( callback(self.playlist, nil), onQueue: queue)
	}

	func removeTrack(_ track: Track,
					 onQueue queue: OperationQueue? = nil,
					 callback: @escaping (Playlist?, PlayError?) -> Void )
	{
		guard let index = playlist.tracks.firstIndex(of: track) else {
			OperationQueue.perform( callback(self.playlist, .trackNotFound), onQueue: queue)
			return
		}

		playlist.tracks.remove(at: index)

		OperationQueue.perform( callback(self.playlist, .trackAlreadyAdded), onQueue: queue)
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
