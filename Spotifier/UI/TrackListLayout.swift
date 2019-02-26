//
//  TrackListLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/26/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class TrackListLayout: BaseGridLayout {

	override func commonInit() {
		super.commonInit()

		sectionInset.left = 8
		sectionInset.right = 8
		minimumLineSpacing = 1
		minimumInteritemSpacing = 0
	}

	override func prepare() {
		defer {
			super.prepare()
		}

		guard var availableWidth = collectionView?.bounds.width else { return }
		availableWidth -= (sectionInset.left + sectionInset.right)
		itemSize = CGSize(width: availableWidth, height: 80)
	}
}

