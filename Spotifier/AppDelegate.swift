//
//  AppDelegate.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/11/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	//MARK:- Middleware

	//	All the shared instances are kept here,
	//	since AppDelegate is the only object that is always in memory
	lazy var spotify: Spotify = Spotify()
	lazy var dataManager: DataManager = DataManager(spotify: spotify)
	lazy var accountManager: AccountManager = AccountManager(dataManager: dataManager)
	lazy var contentManager: ContentManager = ContentManager(dataManager: dataManager)

	//	Current value of all non-UI in use
	var appDependency: AppDependency?




	//	MARK:- Lifecycle

	func application(_ application: UIApplication,
					 willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window = UIWindow(frame: UIScreen.main.bounds)

		buildDependencies()
		applyTheme()

		return true
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		setupUI()

		window?.makeKeyAndVisible()
		return true
	}
}



//MARK:- Private

private extension AppDelegate {
	///	Global theme (look & feel) for the app
	func applyTheme() {
		guard let nc = window?.rootViewController as? UINavigationController else { return }
		nc.navigationBar.barStyle = .blackTranslucent
	}

	///	Build `appDependency` value as many times as you need
	func buildDependencies() {
		appDependency = AppDependency(spotify: spotify,
									  dataManager: dataManager,
									  accountManager: accountManager,
									  contentManager: contentManager)
	}

	///	Built UI stack and supply the dependencies into it
	func setupUI() {
		let vc = UIViewController()
		let nc = UINavigationController(rootViewController: vc)
		window?.rootViewController = nc
	}
}
