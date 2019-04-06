//
//  Content-CoordinatingResponder.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/21/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

extension UIResponder {
	@objc func contentDisplayAlbum(_ album: Album,
								   onQueue queue: OperationQueue? = .main,
								   sender: Any?)
	{
		coordinatingResponder?.contentDisplayAlbum(album, onQueue: queue, sender: sender)
	}

	@objc func contentDisplayArtist(_ artist: Artist,
									onQueue queue: OperationQueue? = .main,
									sender: Any?)
	{
		coordinatingResponder?.contentDisplayArtist(artist, onQueue: queue, sender: sender)
	}

	@objc func contentSearch(for term: String,
							 onQueue queue: OperationQueue? = nil,
							 sender: Any?,
							 callback: @escaping (String, [SearchResultBox], Error?) -> Void)
	{
		coordinatingResponder?.contentSearch(for: term, onQueue: queue, sender: sender, callback: callback)
	}
}
