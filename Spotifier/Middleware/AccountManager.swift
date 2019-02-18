//
//  AccountManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

final class AccountManager: NSObject {
	private var dataManager: DataManager

	//	Init

	init(dataManager: DataManager) {
		self.dataManager = dataManager

		super.init()
	}
}
