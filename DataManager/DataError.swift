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

extension DataError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .generalError(let error):
			return error.localizedDescription

		case .spotifyError(let spotifyError):
			return spotifyError.errorDescription

		case .jsonError(let marshalError):
			return marshalError.localizedDescription
		}
	}

	var failureReason: String? {
		switch self {
		case .generalError:
			return nil

		case .spotifyError(let spotifyError):
			return spotifyError.failureReason

		case .jsonError:
			return nil
		}
	}
}
