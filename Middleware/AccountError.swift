//
//  AccountError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/18/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

enum AccountError: Error {
	case dataError(DataError)
}

extension AccountError: LocalizedError {
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
