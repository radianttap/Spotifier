//
//  AlbumCell.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/20/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class AlbumCell: UICollectionViewCell, NibReusableView {
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var yearLabel: UILabel!
	@IBOutlet private var photoView: UIImageView!
	@IBOutlet private var photoContainerView: UIView!

	override func awakeFromNib() {
		super.awakeFromNib()

		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}
}

extension AlbumCell {
	func populate(with item: Album) {
		titleLabel.text = item.name
		yearLabel.text = item.details
		item.populateImageView(photoView, with: item.imageURL)
	}
}

private extension AlbumCell {
	func cleanup() {
		titleLabel.text = nil
		yearLabel.text = nil
		photoView.image = nil
	}
}
