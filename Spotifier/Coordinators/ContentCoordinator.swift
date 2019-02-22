//
//  ContentCoordinator.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 2/21/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class ContentCoordinator: NavigationCoordinator {
	var appDependency: AppDependency?

	enum Page {
		case search
		case album(Album)
		case artist(Artist)
	}
	var page: Page = .search


	//	MARK:- Lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		super.start(with: completion)

		setupContent()
	}

	override func activate() {
		super.activate()

		setupContent()
	}


	//	MARK:- coordinatingResponder

	override func contentDisplayAlbum(_ album: Album, onQueue queue: OperationQueue?, sender: Any?) {
		page = .album(album)
		setupContent()
	}

	override func contentDisplayArtist(_ artist: Artist, onQueue queue: OperationQueue?, sender: Any?) {
		page = .artist(artist)
		setupContent()
	}
}

//	MARK:- Private

private extension ContentCoordinator {
	func setupContent() {

		switch page {
		case .search:
			let vc = SearchController.instantiate()
			vc.dataSource = SearchDataSource()
			root(vc)

		case .album(let album):
			let vc = AlbumController.instantiate()
			vc.album = album
			show(vc)

		case .artist(let artist):
			let vc = ArtistController.instantiate()
			vc.artist = artist
			show(vc)
		}
	}
}
