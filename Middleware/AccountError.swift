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
