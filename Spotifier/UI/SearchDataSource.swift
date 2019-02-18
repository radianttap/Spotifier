//
//  SearchDataSource.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 11/23/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class SearchDataSource: NSObject {
	//	Initialization

	private weak var collectionView: UICollectionView?

	init(collectionView: UICollectionView) {
		self.collectionView = collectionView
		super.init()

		collectionView.register(SearchCell.self)
		collectionView.register(LargeHeader.self, kind: UICollectionView.elementKindSectionHeader)
	}



	//	Public Data model

	var searchTerm: String? {
		didSet {
			performSearch()
		}
	}

	var results: [SearchResult] = [] {
		didSet {
			processResults()
		}
	}



	//	Internal data model

	private var orderedResults: [Spotify.SearchType: [SearchResult]] = [:]

	private var orderedSearchTypes: [Spotify.SearchType] = [] {
		didSet {
			collectionView?.reloadData()
		}
	}

	private var searchWorkItem: DispatchWorkItem?
}



//	MARK:- Private

private extension SearchDataSource {
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

			keys.append(searchType)
		}

		orderedResults = d
		orderedSearchTypes = keys
	}

	/// Prepares search request, wrapped inside `DispatchWorkItem`
	///	so it can be cancelled if customer continues typing into the UITextField
	func performSearch() {
		searchWorkItem?.cancel()

		let wi = DispatchWorkItem {
			[weak self] in
			self?.search()
		}

		searchWorkItem = wi
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: wi)
	}

	///	Actual search request
	func search() {
		guard let s = searchTerm, s.count > 0 else {
			results = []
			return
		}

		searchWorkItem = nil

		#warning("Execute search on DATA layer")
	}
}




//	MARK:- UICollectionView.DataSource

extension SearchDataSource: UICollectionViewDataSource {
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

extension SearchDataSource {
	func object(at indexPath: IndexPath) -> SearchResult? {
		let key = orderedSearchTypes[indexPath.section]
		guard let items = orderedResults[key] else { return nil }

		let item = items[indexPath.item]
		return item
	}
}
