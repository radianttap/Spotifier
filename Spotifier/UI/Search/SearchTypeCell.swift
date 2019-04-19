//
//  SearchTypeCell.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 04/19/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchTypeCell: UICollectionViewCell, NibReusableView {
	//	UI

	@IBOutlet private var label: UILabel!
	@IBOutlet private var sep: UIView!

	//	Cell lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()

		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}

	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		guard let attr = layoutAttributes.copy() as? UICollectionViewLayoutAttributes else { return layoutAttributes }

		let fittedSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
												 withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel,
												 verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
		attr.frame.size.width = max(fittedSize.width, 54)
		attr.frame = attr.frame.integral
		return attr
	}
}

extension SearchTypeCell {
	func populate(with title: String) {
		label.text = title
	}
}

private extension SearchTypeCell {
	func cleanup() {
		label.text = nil
	}

}
