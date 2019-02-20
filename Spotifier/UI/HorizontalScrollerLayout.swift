//
//  HorizontalScrollerLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/20/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

class HorizontalScrollerLayout: BaseGridLayout {
	override func commonInit() {
		super.commonInit()

		scrollDirection = .horizontal
	}

	override func prepare() {
		defer {
			super.prepare()
		}

		guard let cv = collectionView else { return }

		var availableHeight = cv.bounds.height
		availableHeight -= (sectionInset.top + sectionInset.bottom)
		availableHeight -= (cv.contentInset.top + cv.contentInset.bottom)

		itemSize = CGSize(width: availableHeight * 2/3, height: availableHeight)
	}
}
