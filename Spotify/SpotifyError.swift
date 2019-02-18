//
//  SpotifyError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import Foundation
import Avenue

enum SpotifyError: Error {
	case networkError(NetworkError)
	case invalidResponseType
	case emptyResponse
	case unexpectedResponse(HTTPURLResponse, String?)
	case httpError(HTTPURLResponse)
}
