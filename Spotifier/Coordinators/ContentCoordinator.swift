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
	var appDependency: AppDependency? {
		didSet { processQueuedMessages() }
	}

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

	override func handlePopBack(to vc: UIViewController?) {
		guard let vc = vc else { return }
		recognizePage(for: vc)
	}

	//	MARK:- coordinatingResponder

	override func contentDisplayAlbum(_ album: Album, onQueue queue: OperationQueue?, sender: Any?) {
		page = .album(album)
		setupContent(for: sender)
	}

	override func contentDisplayArtist(_ artist: Artist, onQueue queue: OperationQueue?, sender: Any?) {
		page = .artist(artist)
		setupContent(for: sender)
	}

	override func playEnqueueTrack(_ track: Track, cell: UIView? = nil, onQueue queue: OperationQueue? = .main, sender: Any?, callback: @escaping (Playlist?, Error?) -> Void = {_, _ in}) {
		guard let playManager = appDependency?.playManager else {
			enqueueMessage { [weak self] in self?.playEnqueueTrack(track, onQueue: queue, sender: sender, callback: callback) }
			return
		}

		playManager.queueTrack(track, callback: callback)
	}
}

//	MARK:- Private

private extension ContentCoordinator {
	func setupSearchDataSource(for vc: SearchController) {
		guard let cm = appDependency?.contentManager else {
			enqueueMessage {
				[weak self, weak vc] in
				guard let self = self, let vc = vc else { return }

				self.setupSearchDataSource(for: vc)
			}
			return
		}

		vc.dataSource = SearchDataSource(contentManager: cm)
	}

	func setupContent(for sender: Any? = nil) {
		switch page {
		case .search:
			let vc = SearchController.instantiate()
			setupSearchDataSource(for: vc)
			root(vc)

		case .album(let album):
			let vc = AlbumController.instantiate()
			vc.album = album
			show(vc)

			appDependency?.contentManager?.refreshAlbum(album, onQueue: .main) {
				updatedAlbum, _ in
				vc.album = updatedAlbum
			}

		case .artist(let artist):
			let vc = ArtistController.instantiate()
			vc.artist = artist
			show(vc)

			appDependency?.contentManager?.fetchAlbums(for: artist, onQueue: .main) {
				updatedArtist, _ in
				vc.artist = updatedArtist
			}

		}
	}

	func recognizePage(for vc: UIViewController) {
		switch vc {
		case is SearchController:
			page = .search

		case let vc as AlbumController:
			if let album = vc.album {
				page = .album(album)
			}

		case let vc as ArtistController:
			if let artist = vc.artist {
				page = .artist(artist)
			}

		default:
			break
		}
	}
}
