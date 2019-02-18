//
//  SearchCell.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 11/23/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchCell: UICollectionViewCell, NibReusableView {
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var detailsLabel: UILabel!
	@IBOutlet private var photoView: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()

		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}
}

extension SearchCell {
	func populate(with item: SearchResult) {

		nameLabel.text = item.name
		detailsLabel.text = item.details
		item.populateImageView(photoView, with: item.imageURL)
	}
}

private extension SearchCell {
	func cleanup() {
		nameLabel.text = nil
		detailsLabel.text = nil
		photoView.image = nil
	}

}
