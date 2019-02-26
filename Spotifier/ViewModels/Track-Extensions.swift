//
//  Track-Extensions.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/26/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension Track {
	var formattedDuration: String {
		let duration = Int(durationInMilliseconds)
		let oneSecond = 1000
		let oneMinute = 60 * oneSecond
		let minutes = duration / oneMinute
		let seconds = (duration % (minutes * oneMinute)) / oneSecond

		let s = String(format: "%02d:%02d", minutes, seconds)
		return s
	}
}
