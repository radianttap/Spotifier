//
//  PlayerController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class PlayerController: UICollectionViewController {
	init() {
		let l = TrackListLayout()
		super.init(collectionViewLayout: l)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//	Data source

	var tracks: [Track] = []
}

extension PlayerController {
	// View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupCollectionView()
		populate()
	}
}

private extension PlayerController {
	func populate() {
		collectionView.reloadData()
	}

	func setupCollectionView() {
		collectionView.register(TrackCell.self)
	}
}

extension PlayerController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tracks.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let track = tracks[indexPath.item]

		let cell: TrackCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		cell.populate(with: track, context: .playlist)
		return cell
	}
}
