//
//  SearchResultsLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/19/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchResultsLayout: PlainListLayout {

	override func commonInit() {
		super.commonInit()

		sectionInset.left = 20
		sectionInset.right = 20
		sectionInset.bottom = 44
		minimumLineSpacing = 8
		minimumInteritemSpacing = 0

		itemHeight = 88
	}
}
