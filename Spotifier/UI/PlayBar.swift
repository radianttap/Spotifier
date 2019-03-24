//
//  PlayBar.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class PlayBar: UIView, NibLoadableFinalView {
	//	UI

	@IBOutlet private var toggleButton: UIButton!
	@IBOutlet private var closeButton: UIButton!

	override func awakeFromNib() {
		super.awakeFromNib()

//		toggleButton.alpha = 0
		closeButton.alpha = 0
	}
}

private extension PlayBar {
	@IBAction func open(_ sender: UIButton) {
		//	display playlist

		//	switch buttons
		UIView.animate(withDuration: 0.3) {
			self.closeButton.alpha = 1
			self.toggleButton.alpha = 0
		}
	}

	@IBAction func close(_ sender: UIButton) {
		//	hide playlist, restore previous UI

		//	switch buttons
		UIView.animate(withDuration: 0.3) {
			self.closeButton.alpha = 0
			self.toggleButton.alpha = 1
		}
	}
}
