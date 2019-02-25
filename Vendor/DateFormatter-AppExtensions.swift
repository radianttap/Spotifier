//
//  DateFormatter-Extensions.swift
//

import Foundation

extension DateFormatter {
	static let iso8601NoTimeZoneFormatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_US_POSIX")
		df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		return df
	}()

	//	MARK:- Formatters to use when converting dates in from Spotify's JSONs

	static let spotifyReleaseDayFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd"
		return df
	}()

	static let spotifyReleaseMonthFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM"
		return df
	}()

	static let spotifyReleaseYearFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "yyyy"
		return df
	}()

	//	MARK:- Formatters to use when displaying data in the UI

	static let releaseDayDisplayFormatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = .current
		df.dateFormat = dateFormat(fromTemplate: "ddMMMyyyy", options: 0, locale: .current) ?? "dd MMM yyyy"
		return df
	}()

	static let releaseMonthDisplayFormatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = .current
		df.dateFormat = dateFormat(fromTemplate: "MMMyyyy", options: 0, locale: .current) ?? "MMM yyyy"
		return df
	}()

	static let releaseYearDisplayFormatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = .current
		df.dateFormat = dateFormat(fromTemplate: "yyyy", options: 0, locale: .current) ?? "yyyy"
		return df
	}()
}
