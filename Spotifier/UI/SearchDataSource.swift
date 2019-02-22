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

	weak var collectionView: UICollectionView? {
		didSet {
			prepareCollectionView()
		}
	}


	//	Data model (input)

	var searchTerm: String? {
		didSet {
			prepareSearchRequest()
		}
	}

	var results: [SearchResult] = [] {
		didSet {
			processResults()
		}
	}


	//	Exit (output)

	func executeSearch(for s: String) {
		collectionView?.contentSearch(for: s, onQueue: .main, sender: self) {
			[weak self] searchedTerm, boxedResults, error in

			//	race-condition check
			if let lastSearchTerm = self?.searchTerm, lastSearchTerm != searchedTerm { return }

			if let error = error {
				print(error)
				return
			}

			self?.results = boxedResults.unbox
		}
	}


	//	Internal data model (derivatives)

	private var orderedResults: [Spotify.SearchType: [SearchResult]] = [:]

	private var orderedSearchTypes: [Spotify.SearchType] = [] {
		didSet {
			collectionView?.reloadData()
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
			case .track, .playlist:
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
}




//	MARK:- UICollectionView.DataSource

extension SearchDataSource: UICollectionViewDataSource {
	private func prepareCollectionView() {
		collectionView?.register(SearchCell.self)
		collectionView?.register(LargeHeader.self, kind: UICollectionView.elementKindSectionHeader)
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return orderedSearchTypes.count
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let searchType = orderedSearchTypes[indexPath.section]

		let v: LargeHeader = collectionView.dequeueReusableView(kind: kind, atIndexPath: indexPath)
		v.populate(with: searchType.headerTitle)
		return v
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let key = orderedSearchTypes[section]
		return orderedResults[key]?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let item = object(at: indexPath) else {
			fatalError("No SearchResult instance found at indexPath: \( indexPath )")
		}

		let cell: SearchCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		cell.populate(with: item)
		return cell
	}
}

//	MARK:- Public

extension SearchDataSource {
	func object(at indexPath: IndexPath) -> SearchResult? {
		let key = orderedSearchTypes[indexPath.section]
		guard let items = orderedResults[key] else { return nil }

		let item = items[indexPath.item]
		return item
	}
}
