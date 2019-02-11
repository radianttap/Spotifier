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


	//	MARK:- Lifecycle

	func application(_ application: UIApplication,
					 willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window = UIWindow(frame: UIScreen.main.bounds)

		let vc = UIViewController()
		let nc = UINavigationController(rootViewController: vc)
		window?.rootViewController = nc

		applyTheme()

		return true
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window?.makeKeyAndVisible()
		return true
	}
}


private extension AppDelegate {
	func applyTheme() {
		guard let nc = window?.rootViewController as? UINavigationController else { return }
		nc.navigationBar.barStyle = .blackTranslucent
	}
}
