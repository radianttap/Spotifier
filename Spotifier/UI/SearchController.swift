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


	//	MARK:- Exit (output)

	private func displayArtist(_ artist: Artist) {
		let vc = ArtistController.instantiate()
		vc.artist = artist
		show(vc, sender: self)
	}

	private func displayAlbum(_ album: Album) {
		let vc = AlbumController.instantiate()
		vc.album = album
		show(vc, sender: self)
	}
}



//	MARK:- View lifecycle

extension SearchController {
	override func viewDidLoad() {
		super.viewDidLoad()

		prepareDataSource()
		setupUI()

		applyTheme()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		collectionView.contentInset.top = searchBox.bounds.height
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
		guard let item = dataSource.object(at: indexPath) else { return }

		switch item {
		case let artist as Artist:
			displayArtist(artist)

		case let album as Album:
			displayAlbum(album)

		default:
			break
		}
	}
}



//	MARK:- Private

private extension SearchController {
	func applyTheme() {
		view.backgroundColor = .black
		collectionView.backgroundColor = view.backgroundColor
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
	}
}
