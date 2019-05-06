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

	var album: Album? {
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
	@IBOutlet private var collectionView: UICollectionView!
}

extension AlbumController {
	// View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupCollectionView()
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

		collectionView.reloadData()
	}


	func setupCollectionView() {
		collectionView.register(TrackCell.self)

		collectionView.dataSource = self
		collectionView.delegate = self
	}
}

extension AlbumController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return album?.tracks.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let track = album?.tracks[indexPath.item] else {
			fatalError("No track at indexPath: \( indexPath )")
		}

		let cell: TrackCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		cell.populate(with: track, context: .album)
		return cell
	}
}

extension AlbumController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let track = album?.tracks[indexPath.item] else {
			fatalError("No track at indexPath: \( indexPath )")
		}

		let cell = collectionView.cellForItem(at: indexPath)
		playEnqueueTrack(track, cell: cell, onQueue: .main, sender: self)
	}
}

