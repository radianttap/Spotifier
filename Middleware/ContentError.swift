//
//  ContentError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/9/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation

enum ContentError: Error {
	case dataError(DataError)
}

extension ContentError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .dataError(let dataError):
			return dataError.errorDescription
		}
	}

	var failureReason: String? {
		switch self {
		case .dataError(let dataError):
			return dataError.failureReason
		}
	}
}
