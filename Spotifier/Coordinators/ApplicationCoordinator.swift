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

	init(application: UIApplication, rootViewController: UINavigationController?) {
		self.application = application
		super.init(rootViewController: rootViewController)
	}

}
