//
//  NavigationController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
	//	UI

	private lazy var playBar: PlayBar = PlayBar.nibInstance

	//	DataModel

	var isPlayBarVisible: Bool = false {
		didSet {
			if !isViewLoaded { return }
			processPlayBarVisibility()
		}
	}
}

extension NavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupPlayBar()
		processPlayBarVisibility()
	}
}

private extension NavigationController {
	func setupPlayBar() {
		playBar.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(playBar)

		playBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
		playBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
		playBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
	}

	func processPlayBarVisibility() {
		playBar.alpha = isPlayBarVisible ? 1 : 0
	}
}
