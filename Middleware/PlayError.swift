//
//  PlayError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/16/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

enum PlayError: Error {
	case trackAlreadyAdded
	case trackNotFound
}

extension PlayError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .trackAlreadyAdded, .trackNotFound:
			return NSLocalizedString("Failed", comment: "")
		}
	}

	var failureReason: String? {
		switch self {
		case .trackAlreadyAdded:
			return NSLocalizedString("Track already added", comment: "")

		case .trackNotFound:
			return NSLocalizedString("Track not found", comment: "")
		}
	}
}
