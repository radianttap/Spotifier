//
//  Play-CoordinatingResponder.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/6/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension UIResponder {
	//	Navigation

	@objc func playShowPlayer(onQueue queue: OperationQueue? = .main, sender: Any? = nil) {
		coordinatingResponder?.playShowPlayer(onQueue: queue, sender: sender)
	}

	@objc func playHidePlayer(onQueue queue: OperationQueue? = .main, sender: Any? = nil) {
		coordinatingResponder?.playHidePlayer(onQueue: queue, sender: sender)
	}


	//	Actions

	@objc func playTrackNow(_ track: Track,
							onQueue queue: OperationQueue? = .main,
							sender: Any?,
							callback: @escaping (Playlist?, Error?) -> Void = {_, _ in})
	{
		coordinatingResponder?.playTrackNow(track, onQueue: queue, sender: sender, callback: callback)
	}

	@objc func playEnqueueTrack(_ track: Track,
								cell: UIView? = nil,
								onQueue queue: OperationQueue? = .main,
								sender: Any?,
								callback: @escaping (Playlist?, Error?) -> Void = {_, _ in})
	{
		coordinatingResponder?.playEnqueueTrack(track, cell: cell, onQueue: queue, sender: sender, callback: callback)
	}
}
