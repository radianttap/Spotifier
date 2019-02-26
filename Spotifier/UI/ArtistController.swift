//
//  ArtistController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class ArtistController: UIViewController, StoryboardLoadable {
	//	Data model

	var artist: Artist? {
		didSet {
			if !isViewLoaded { return }
			populate()
		}
	}

	//	UI

	@IBOutlet private var collectionView: UICollectionView!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var detailsLabel: UILabel!
	@IBOutlet private var photoView: UIImageView!
}

extension ArtistController {
	// View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupCollectionView()
		populate()
	}
}

private extension ArtistController {
	func cleanup() {
		nameLabel.text = nil
		detailsLabel.text = nil
		photoView.image = nil
		collectionView.reloadData()
	}

	func populate() {
		guard let artist = artist else {
			cleanup()
			return
		}

		nameLabel.text = artist.name
		detailsLabel.text = artist.cardContents
		artist.populateImageView(photoView, with: artist.imageURL)

		collectionView.reloadData()
	}

	func setupCollectionView() {
		collectionView.register(AlbumCell.self)

		collectionView.dataSource = self
		collectionView.delegate = self
	}
}

extension ArtistController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return artist?.albums.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let album = artist?.albums[indexPath.item] else {
			fatalError("No album at indexPath: \( indexPath )")
		}

		let cell: AlbumCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		cell.populate(with: album)
		return cell
	}
}

extension ArtistController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let album = artist?.albums[indexPath.item] else {
			return
		}

		contentDisplayAlbum(album, sender: self)
	}
}

