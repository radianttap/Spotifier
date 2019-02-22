// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

final class SearchResultBox: NSObject {
	let unbox: SearchResult
	init(_ value: SearchResult) {
		self.unbox = value
	}
}
extension SearchResult {
	var boxed: SearchResultBox { return SearchResultBox(self) }
}


