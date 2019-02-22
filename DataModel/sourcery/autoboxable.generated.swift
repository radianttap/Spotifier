// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

//	MARK:- SearchResultBox

final class SearchResultBox: NSObject {
	let unbox: SearchResult
	init(_ value: SearchResult) {
		self.unbox = value
	}
}
extension SearchResult {
	var boxed: SearchResultBox { return SearchResultBox(self) }
}
extension Array where Element: SearchResult {
	var boxed: [SearchResultBox] { return self.map{ $0.boxed } }
}
extension Array where Element: SearchResultBox {
	var unboxed: [SearchResult] { return self.map{ $0.unbox } }
}


