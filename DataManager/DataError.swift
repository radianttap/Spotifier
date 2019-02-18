//
//  DataError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/9/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

enum DataError: Error {
	case generalError(Swift.Error)
	case spotifyError(SpotifyError)
	case jsonError(MarshalError)
}
