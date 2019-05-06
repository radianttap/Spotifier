//
//  NavigationController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 3/23/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
	//	UI

	private lazy var playBar: PlayBar = PlayBar.nibInstance

	//	DataModel

	var isPlayBarVisible: Bool = false {
		didSet {
			if !isViewLoaded { return }
			processPlayBarVisibility()
		}
	}

	//	MARK: coordinatingResponder

	override func playEnqueueTrack(_ track: Track, cell: UIView? = nil, onQueue queue: OperationQueue? = .main, sender: Any?, callback: @escaping (Playlist?, Error?) -> Void = {_, _ in}) {
		animatePlayCell(cell)

		coordinatingResponder?.playEnqueueTrack(track, onQueue: queue, sender: sender) {
			[weak self] playlist, playError in

			self?.isPlayBarVisible = (playlist?.tracks.count ?? 0) > 0

			callback(playlist, playError)
		}
	}
}

extension NavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupPlayBar()
		processPlayBarVisibility()
	}
}

private extension NavigationController {
	func setupPlayBar() {
		playBar.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(playBar)

		playBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
		playBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
		playBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
	}

	func processPlayBarVisibility() {
		playBar.alpha = isPlayBarVisible ? 1 : 0
	}

	func animatePlayCell(_ cell: UIView?) {
		guard let cell = cell else { return }

		//	where would the cell be in local view?
		let cellFrame = cell.convert(cell.bounds, to: view)

		//	animate towards PlayBar instance
		let targetFrame = playBar.convert(playBar.bounds, to: view)

		//	create flat snapshot of the cell
		UIGraphicsBeginImageContextWithOptions(cell.bounds.size, true, 0)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		cell.layer.render(in: context)
		guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
		UIGraphicsEndImageContext()

		let cellView = UIImageView(image: image)
		cellView.contentMode = .scaleToFill
		cellView.clipsToBounds = true
		cellView.layer.borderWidth = 2
		cellView.layer.borderColor = view.tintColor.cgColor
		cellView.layer.cornerRadius = 6

		//	animation starts:
		let startFrame = cellFrame

		//	animation ends
		let endFrame = targetFrame

		//	assign starting values now
		cellView.frame = startFrame
		view.addSubview(cellView)

		//	animate position
		let pathAnimation = CAKeyframeAnimation(keyPath: "position")
		pathAnimation.calculationMode = CAAnimationCalculationMode.cubicPaced
		pathAnimation.isRemovedOnCompletion = false
		let endPoint = CGPoint(x: endFrame.midX, y: endFrame.midY)
		let startPoint = CGPoint(x: startFrame.midX, y: startFrame.midY)
		let curvedPath = CGMutablePath()
		curvedPath.move(to: startPoint)
		curvedPath.addCurve(to: endPoint,
							control1: CGPoint(x: endPoint.x / 2, y: endPoint.y),
							control2: CGPoint(x: endPoint.x * 0.8, y: startPoint.y))
		pathAnimation.path = curvedPath

		//	animate frame
		let resizeAnimation = CABasicAnimation(keyPath: "bounds.size")
		resizeAnimation.isRemovedOnCompletion = false
		resizeAnimation.fromValue = startFrame.size
		resizeAnimation.toValue = endFrame.size

		//	animate opacity
		let opacityAnimation = CABasicAnimation(keyPath: "opacity")
		opacityAnimation.isRemovedOnCompletion = false
		opacityAnimation.fromValue = 1
		opacityAnimation.toValue = 0.3

		//	animate all together
		let group = CAAnimationGroup()
		let duration: TimeInterval = 0.8
		group.animations = [resizeAnimation, pathAnimation, opacityAnimation]
		group.duration = duration
		group.setValue(cellView, forKey: "cellView")
		cellView.layer.add(group, forKey: "enqueueTrackAnimation")

		DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
			cellView.removeFromSuperview()
		}
	}
}
