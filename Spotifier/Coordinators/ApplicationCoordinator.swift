//
//  ApplicationCoordinator.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/21/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class ApplicationCoordinator: NavigationCoordinator {
	private weak var application: UIApplication!

	init(application: UIApplication, rootViewController: NavigationController?) {
		self.application = application
		super.init(rootViewController: rootViewController)
	}


	//	MARK:- Middleware

	//	All the shared instances are kept here,
	//	since AppDelegate is the only object that is always in memory
	private lazy var spotify: Spotify = Spotify()
	private lazy var dataManager: DataManager = DataManager(spotify: spotify)
	private lazy var accountManager: AccountManager = AccountManager(dataManager: dataManager)
	private lazy var contentManager: ContentManager = ContentManager(dataManager: dataManager)
	private lazy var playManager: PlayManager = PlayManager()

	//	Current value of all non-UI in use
	var appDependency: AppDependency?



	//	MARK:- Content

	var navigationController: NavigationController {
		return rootViewController as! NavigationController
	}

	enum Section {
		case content(page: ContentCoordinator.Page?)
		case playlist
	}
	var section: Section = .content(page: nil)


	//	MARK:- Lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		buildDependencies()
		super.start(with: completion)

		// The moment when app logic decices what is the first content VC to show
		setupContent()
	}

}


private extension ApplicationCoordinator {
	///	Build `appDependency` value as many times as you need
	func buildDependencies() {
		appDependency = AppDependency(spotify: spotify,
									  dataManager: dataManager,
									  accountManager: accountManager,
									  contentManager: contentManager,
									  playManager: playManager)
	}

	///	Sets up actual content to show, inside rootViewController
	func setupContent() {
		switch section {
		case .content(let page):
			showContent(page: page)
		case .playlist:
			let vc = PlayerController()
			vc.playlist = appDependency?.playManager?.playlist
			root(vc)
		}
	}

	func showContent(page: ContentCoordinator.Page? = nil) {
		let identifier = String(describing: ContentCoordinator.self)

		if let c = childCoordinators[identifier] as? ContentCoordinator {
			c.appDependency = appDependency
			if let page = page {
				c.page = page
			}
			c.activate()
			return
		}

		let c = ContentCoordinator(rootViewController: rootViewController)
		c.appDependency = appDependency
		if let page = page {
			c.page = page
		}
		startChild(coordinator: c)
	}
}
