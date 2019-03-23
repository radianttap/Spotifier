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

			return
		}

		tracks.insert(track, at: 0)
	}

	func removeTrack(_ track: Track) {
		guard let index = tracks.firstIndex(of: track) else { return }

		tracks.remove(at: index)
	}
}
