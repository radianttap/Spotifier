//
//  TrackCell.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/26/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class TrackCell: UICollectionViewCell, NibReusableView {
	@IBOutlet private var highlightedView: UIView!
	@IBOutlet private var photoView: UIImageView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var subtitleLabel: UILabel!
	@IBOutlet private var durationLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		selectedBackgroundView = highlightedView

		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}
}

extension TrackCell {
	func populate(with track: Track, context: Track.UsageContext) {
		titleLabel.text = track.name
		subtitleLabel.text = track.formattedDetails(in: context)
		durationLabel.text = track.formattedDuration

		track.populateImageView(photoView, with: track.imageURL)
	}
}

private extension TrackCell {
	func cleanup() {
		highlightedView.backgroundColor = .clear
		titleLabel.text = nil
		subtitleLabel.text = nil
		durationLabel.text = nil
		photoView.image = nil
	}
}
