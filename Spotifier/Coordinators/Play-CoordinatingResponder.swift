//
//  Play-CoordinatingResponder.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/6/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension UIResponder {
	@objc func playTrackNow(_ track: Track,
							onQueue queue: OperationQueue? = .main,
							sender: Any?,
							callback: @escaping (Playlist?, Error?) -> Void = {_, _ in})
	{
		coordinatingResponder?.playTrackNow(track, onQueue: queue, sender: sender, callback: callback)
	}

	@objc func playEnqueueTrack(_ track: Track,
								onQueue queue: OperationQueue? = .main,
								sender: Any?,
								callback: @escaping (Playlist?, Error?) -> Void = {_, _ in})
	{
		coordinatingResponder?.playEnqueueTrack(track, onQueue: queue, sender: sender, callback: callback)
	}
}
