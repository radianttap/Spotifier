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

	enum Page {
		case search
	}
	var page: Page = .search


	//	MARK:- Lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		super.start(with: completion)

		setupContent()
	}
}

//	MARK:- Private

private extension ContentCoordinator {
	func setupContent() {

		switch page {
		case .search:
			let dataSource = SearchDataSource(appDependency: appDependency)
			let vc = SearchController.instantiate()
			vc.dataSource = dataSource
			root(vc)
		}
	}
}
