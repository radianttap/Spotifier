//
//  SearchController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 5/8/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchController: UIViewController, StoryboardLoadable { // (C)
	//	MARK:- Data model (M)

	var dataSource: SearchDataSource! {
		didSet {
			if !isViewLoaded { return }
			prepareDataSource()
		}
	}


	//	MARK:- UI (V)

	@IBOutlet private var searchBox: UIView!
	@IBOutlet private var searchField: UITextField!
	@IBOutlet private var collectionView: UICollectionView!
	@IBOutlet private var logoHeightConstraint: NSLayoutConstraint!
	@IBOutlet private var containerView: UIView!

	//	MARK: Embedded

	private var resultsController: SearchResultsController?
}



//	MARK:- View lifecycle

extension SearchController {
	override func viewDidLoad() {
		super.viewDidLoad()

		prepareDataSource()
		setupUI()
		embedResultsController()

		applyTheme()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let top = collectionView.frame.maxY - searchBox.frame.minY
		resultsController?.additionalSafeAreaInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
	}
}


//	MARK:- Delegates

extension SearchController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		logoHeightConstraint.isActive = true

		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 16, options: [], animations: {
			[weak self] in
			self?.view.layoutIfNeeded()
		})
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if dataSource.searchTerm?.count ?? 0 > 0 { return }

		logoHeightConstraint.isActive = false

		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 16, options: [], animations: {
			[weak self] in self?.view.layoutIfNeeded()
		})
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	@IBAction private func processSearchFieldTextChange(_ sender: UITextField) {
		dataSource.searchTerm = sender.text
	}
}

extension SearchController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let searchType = dataSource.searchType(at: indexPath)
		let results = dataSource.searchResults(ofType: searchType)
		updateResults(with: results)
	}
}



//	MARK:- Private

private extension SearchController {
	func applyTheme() {
		view.backgroundColor = .black

		//	add blurred background to SearchTypes scroller
		collectionView.backgroundColor = .clear

		let bv = UIVisualEffectView(effect: UIBlurEffect(style: .dark) )
		collectionView.backgroundView = bv
	}

	/// Sets-up UI stuff which are not possible to do in IB
	func setupUI() {
		//	place a loupe glyph on the left of the text field
		let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
		v.contentMode = .center
		v.image = UIImage(imageLiteralResourceName: "icon-search")
		v.tintColor = .gray
		searchField.leftViewMode = .always
		searchField.leftView = v

		//	setup delegate for search text field
		searchField.delegate = self

		//	setup delegate for events in UICollectionView
		collectionView.delegate = self
	}

	func prepareDataSource() {
		dataSource.collectionView = collectionView
		collectionView.dataSource = dataSource

		dataSource.controller = self
	}
}

//	MARK:- Embeds

private extension SearchController {
	func embedResultsController() {
		if resultsController != nil { return }

		let vc = SearchResultsController()
		embed(controller: vc, into: containerView)
		resultsController = vc
	}

	func updateResults(with arr: [SearchResult]) {
		resultsController?.results = arr
	}
}
