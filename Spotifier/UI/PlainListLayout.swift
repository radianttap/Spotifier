//
//  PlainListLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/19/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

class PlainListLayout: BaseGridLayout {
	var itemHeight: CGFloat = 50

	override func prepare() {
		defer {
			super.prepare()
		}

		guard var availableWidth = collectionView?.bounds.width else { return }
		availableWidth -= (sectionInset.left + sectionInset.right)
		itemSize = CGSize(width: availableWidth, height: itemHeight)
	}
}
