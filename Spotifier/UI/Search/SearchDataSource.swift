//
//  SearchDataSource.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 11/23/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchDataSource: NSObject {
	//	Dependencies

	//	Note: DataSource should be testable and usable when this is `nil`
	weak var controller: SearchController?

	//	connection to middleware
	private let contentManager: ContentManager

	init(contentManager: ContentManager) {
		self.contentManager = contentManager
		super.init()
	}





	//	Data model (input)

	var searchTerm: String? {
		didSet {
			prepareSearchRequest()
		}
	}

	var selectedSearchType: Spotify.SearchType? {
		didSet {
			controller?.renderContentUpdates()
		}
	}

	var results: [SearchResult] = [] {
		didSet {
			processResults()
		}
	}


	//	Exit (output)

	func executeSearch(for s: String) {
		contentManager.search(for: s, onQueue: .main) {
			[weak self] searchedTerm, results, error in

			//	race-condition check
			if let lastSearchTerm = self?.searchTerm, lastSearchTerm != searchedTerm { return }

			if let error = error {
				switch error {
				case let error as LocalizedError:
					UIAlertController.alert(error, from: self?.controller)
				default:
					print(error)
				}
				return
			}

			self?.results = results
		}
	}


	//	Internal data model (derivatives)

	private var orderedResults: [Spotify.SearchType: [SearchResult]] = [:]

	private(set) var orderedSearchTypes: [Spotify.SearchType] = [] {
		didSet {
			processContentUpdates()
		}
	}

	//	Helpers

	private var searchWorkItem: DispatchWorkItem?
	private var searchQueue = DispatchQueue.main
}



//	MARK:- Private

private extension SearchDataSource {
	///	Splits combined results per SearchType thus groups Artists, Albums etc.
	///
	///	That builds 2-level hierarchy which is easy to translate into UICVDataSource.
	func processResults() {
		var d: [Spotify.SearchType: [SearchResult]] = [:]
		var keys: [Spotify.SearchType] = []

		for searchType in Spotify.SearchType.allCases {
			let arr = results.filter{ $0.searchType == searchType }

			switch searchType {
			case .artist:
				d[searchType] = (arr as! [Artist]).sorted { $0.followersCount > $1.followersCount }
			case .album:
				d[searchType] = arr.sorted { $0.name < $1.name }
			case .track:
				d[searchType] = (arr as! [Track]).sorted { $0.popularity > $1.popularity }
			case .playlist:
				break
			}

			if arr.count > 0 {
				keys.append(searchType)
			}
		}

		orderedResults = d
		orderedSearchTypes = keys
	}

	/// Prepares search request, wrapped inside `DispatchWorkItem`
	///	so it can be cancelled if customer continues typing into the UITextField.
	func prepareSearchRequest() {
		searchWorkItem?.cancel()

		guard let s = searchTerm, s.count > 0 else {
			results = []
			return
		}

		let wi = DispatchWorkItem {
			[weak self] in
			self?.executeSearch(for: s)
			self?.searchWorkItem = nil
		}
		searchWorkItem = wi
		searchQueue.asyncAfter(deadline: .now() + 0.3, execute: wi)
	}

	func processContentUpdates() {
		if let searchType = selectedSearchType {
			//	make sure this is still valid for the current results
			if !orderedSearchTypes.contains(searchType) {
				selectedSearchType = nil
			}
		}

		if selectedSearchType == nil {
			selectedSearchType = orderedSearchTypes.first
		}

		controller?.renderContentUpdates()
	}
}




//	MARK:- UICollectionView.DataSource

extension SearchDataSource: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return orderedSearchTypes.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let key = orderedSearchTypes[indexPath.row]

		let cell: SearchTypeCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		cell.populate(with: key.headerTitle)
		return cell
	}

	//	MARK: Helpers, for UIViewController to use

	func searchType(at indexPath: IndexPath) -> Spotify.SearchType {
		let key = orderedSearchTypes[indexPath.row]
		return key
	}

	func searchResults(ofType key: Spotify.SearchType) -> [SearchResult] {
		guard let items = orderedResults[key] else { return [] }
		return items
	}
}
