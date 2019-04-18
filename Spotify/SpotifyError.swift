//
//  SpotifyError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Avenue
import SwiftyOAuth

enum SpotifyError: Swift.Error {
	case invalidBaseURL(basePath: String)
	case invalidFinalURL(url: URL, queryParams: JSON)
	case requestBuildFailed(Swift.Error)

	case networkError(NetworkError)
	case invalidResponseType
	case emptyResponse
	case unexpectedResponse(HTTPURLResponse, String?)
	case httpError(HTTPURLResponse)

	case invalidAuthToken
	case authError(SwiftyOAuth.Error)
}


extension SpotifyError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidBaseURL, .invalidFinalURL, .requestBuildFailed:
			return NSLocalizedString("Internal error", comment: "")

		case .invalidResponseType, .emptyResponse, .unexpectedResponse, .httpError:
			return NSLocalizedString("Invalid or unexpected response from Spotify", comment: "")

		case .networkError(let netErr):
			return netErr.errorDescription

		case .invalidAuthToken:
			return NSLocalizedString("Authorization error", comment: "")

		case .authError(let authError):
			return authError.errorDescription
		}
	}

	var failureReason: String? {
		switch self {
		case .invalidBaseURL(let basePath):
			return String(format: NSLocalizedString("Failed to build URL using: %@", comment: ""), basePath)

		case .invalidFinalURL(let url, let queryParams):
			return String(format: NSLocalizedString("Failed to build URL using: %@ and query-string parameters: %@", comment: ""), url.path, queryParams)

		case .requestBuildFailed(let error):
			return String(format: NSLocalizedString("Failed to build URLRequest: %@", comment: ""), error.localizedDescription)

		case .invalidResponseType:
			return NSLocalizedString("Unexpected response (non HTTP)", comment: "")

		case .emptyResponse:
			return NSLocalizedString("Empty response received (no data)", comment: "")

		case .unexpectedResponse(let httpURLResponse, let str):
			let s = str ?? String(describing: httpURLResponse.allHeaderFields)
			return s

		case .httpError(let httpURLResponse):
			return String(describing: httpURLResponse.allHeaderFields)

		case .networkError(let netErr):
			return netErr.failureReason

		case .invalidAuthToken:
			return NSLocalizedString("Authorization token is missing or expired", comment: "")

		case .authError(let authError):
			return authError.failureReason
		}
	}
}
