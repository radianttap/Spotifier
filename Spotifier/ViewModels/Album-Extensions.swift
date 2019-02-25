//
//  Album-Extensions.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/25/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension Album {
	var formattedReleaseDate: String? {
		guard
			let releaseDatePrecision = releaseDatePrecision,
			let date = releaseDate
		else { return nil }

		switch releaseDatePrecision {
		case .year:
			return DateFormatter.releaseYearDisplayFormatter.string(from: date)
		case .month:
			return DateFormatter.releaseMonthDisplayFormatter.string(from: date)
		case .day:
			return DateFormatter.releaseDayDisplayFormatter.string(from: date)
		}
	}
}
