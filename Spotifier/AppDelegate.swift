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
	var applicationCoordinator: ApplicationCoordinator!




	//	MARK:- Lifecycle

	func application(_ application: UIApplication,
					 willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window = UIWindow(frame: UIScreen.main.bounds)

		applicationCoordinator = {
			let nc = NavigationController()
			let c = ApplicationCoordinator(application: application, rootViewController: nc)
			return c
		}()
		window?.rootViewController = applicationCoordinator.rootViewController
		applyTheme()

		return true
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window?.makeKeyAndVisible()
		applicationCoordinator.start()
		return true
	}
}



//	MARK:- Private

private extension AppDelegate {
	///	Global theme (look & feel) for the app
	func applyTheme() {
		guard let nc = window?.rootViewController as? UINavigationController else { return }
		nc.navigationBar.barStyle = .blackTranslucent

		window?.tintColor = UIColor(hex: "63CD6C")
	}
}
