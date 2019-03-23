//
//  PlayManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

final class PlayManager {

	private(set) var tracks: [Track] = []
	private(set) var currentTrack: Track?
}

extension PlayManager {
	func queueTrack(_ track: Track) {
		if tracks.contains(track) { return }

		tracks.append(track)
	}

	func playTrack(_ track: Track) {
		if let index = tracks.firstIndex(of: track) {
			if index == 0 { return }
			let t = tracks.remove(at: index)
			tracks.insert(t, at: 0)

			play(track: t)
			return
		}

		tracks.insert(track, at: 0)
		play(track: track)
	}

	func removeTrack(_ track: Track) {
		guard let index = tracks.firstIndex(of: track) else { return }

		tracks.remove(at: index)
	}
}


extension PlayManager {
	func play(track: Track? = nil) {
		guard let t = track ?? tracks.first else { return }

		currentTrack = t
	}

	func pause() {

	}

	func stop() {
		currentTrack = nil
	}

	func next() {
		guard let currentTrack = currentTrack else {
			play(track: tracks.first)
			return
		}

		guard
			let index = tracks.firstIndex(of: currentTrack),
			index < tracks.count - 1
		else { return }

		let t = tracks[index + 1]
		play(track: t)
	}

	func previous() {
		guard let currentTrack = currentTrack else {
			return
		}

		guard
			let index = tracks.firstIndex(of: currentTrack),
			index > 0
		else { return }

		let t = tracks[index - 1]
		play(track: t)
	}
}
