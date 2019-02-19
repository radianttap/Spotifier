//
//  AlbumController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class AlbumController: UIViewController, StoryboardLoadable {
	//	Data model

	var album: Album?

	//	UI






	// View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = album?.name
	}
}

