//
//  ContentCoordinator.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/21/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class ContentCoordinator: NavigationCoordinator {
	var appDependency: AppDependency?


	override func start(with completion: @escaping () -> Void = {}) {
		super.start(with: completion)

		setupContent()
	}
}

private extension ContentCoordinator {
	func setupContent() {

	}
}
