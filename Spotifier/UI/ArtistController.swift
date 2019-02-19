//
//  ArtistController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class ArtistController: UIViewController, StoryboardLoadable {
	//	Data model

	var artist: Artist?

	//	UI





	// View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = artist?.name
	}
}

