//
//  SearchTypesLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/19/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchTypesLayout: BaseGridLayout {

	override func commonInit() {
		super.commonInit()

		sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
		minimumLineSpacing = 20
		scrollDirection = .horizontal
		estimatedItemSize = CGSize(width: 120, height: 54)
		itemSize = estimatedItemSize
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return false
	}

	override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
		return preferredAttributes.frame.size != originalAttributes.frame.size
	}
}
