//
//  SearchResult-Extensions.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/18/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit
import Kingfisher

extension SearchResult {
	func populateImageView(_ imageView: UIImageView?, with url: URL? = nil) {
		guard let imageView = imageView else { return }

		guard let url = url else {
			imageView.image = nil
			return
		}

		imageView.kf.setImage(with: url)
	}
}
