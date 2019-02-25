//
//  AlbumController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class AlbumController: UIViewController, StoryboardLoadable {
	//	Data model

	var album: Album?{
		didSet {
			if !isViewLoaded { return }
			populate()
		}
	}

	//	UI

	@IBOutlet private var photoView: UIImageView!
	@IBOutlet private var photoContainerView: UIView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var yearLabel: UILabel!
	@IBOutlet private var artistLabel: UILabel!
}

extension AlbumController {
	// View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		populate()
	}
}

private extension AlbumController {
	func cleanup() {
		titleLabel.text = nil
		yearLabel.text = nil
		artistLabel.text = nil
		photoView.image = nil
	}

	func populate() {
		guard let album = album else {
			cleanup()
			return
		}

		titleLabel.text = album.name
		yearLabel.text = album.formattedReleaseDate
		artistLabel.text = album.artists.map{ $0.name }.joined(separator: ", ")
		album.populateImageView(photoView, with: album.imageURL)
	}
}

