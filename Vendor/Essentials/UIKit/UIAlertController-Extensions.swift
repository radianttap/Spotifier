//
//  UIAlertController-Extensions.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 4/18/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension UIAlertController {
	convenience init(_ error: LocalizedError, preferredStyle: UIAlertController.Style) {
		let title = error.errorDescription

		let message = [
			error.failureReason,
			error.recoverySuggestion
		].compactMap { $0 }.joined(separator: "\n\n")

		self.init(title: title,
				  message: message,
				  preferredStyle: .alert)
	}

	static func alert(_ error: LocalizedError, from controller: UIViewController? = nil) {
		let ac = UIAlertController(error, preferredStyle: .alert)
		ac.addAction(
			UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
		)

		let presenter = controller ?? UIApplication.shared.keyWindow?.rootViewController
		presenter?.present(ac, animated: true)
	}
}
