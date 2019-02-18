//
//  AppDependency.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/10/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

struct AppDependency {
	var spotify: Spotify?
	var dataManager: DataManager?
	var accountManager: AccountManager?
	var contentManager: ContentManager?

	//	Init

	init(spotify: Spotify? = nil,
		 dataManager: DataManager? = nil,
		 accountManager: AccountManager? = nil,
		 contentManager: ContentManager? = nil)
	{
		self.spotify = spotify
		self.dataManager = dataManager
		self.accountManager = accountManager
		self.contentManager = contentManager
	}
}

