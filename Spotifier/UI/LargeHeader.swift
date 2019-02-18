//
//  LargeHeader.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 11/23/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class LargeHeader: UICollectionReusableView, NibReusableView {
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
}

extension LargeHeader {
	func populate(with title: String) {
		label.text = title
	}
}

private extension LargeHeader {
	func cleanup() {
		label.text = nil
	}

}
