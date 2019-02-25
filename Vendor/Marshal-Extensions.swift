//
//  Marshal-Extensions.swift

//	Note:
//	These are general extensions, tailored for this app

import Foundation
import Marshal

//	http://aplus.rs/2018/extending-marshal-for-dates/
extension Date : ValueType {
	public static func value(from object: Any) throws -> Date {
		switch object {
		case let date as Date:
			return date

		case let dateString as String:
			if let date = DateFormatter.iso8601Formatter.date(from: dateString) {
				return date
			} else if let date = DateFormatter.iso8601FractionalSecondsFormatter.date(from: dateString) {
				return date
			} else if let date = DateFormatter.iso8601NoTimeZoneFormatter.date(from: dateString) {
				return date
			} else if let date = DateFormatter.spotifyReleaseDayFormatter.date(from: dateString) {
				return date
			} else if let date = DateFormatter.spotifyReleaseMonthFormatter.date(from: dateString) {
				return date
			} else if let date = DateFormatter.spotifyReleaseYearFormatter.date(from: dateString) {
				return date
			}
			throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)

		case let dateNum as Int64:
			return Date(timeIntervalSince1970: TimeInterval(integerLiteral: dateNum) )

		case let dateNum as Double:
			return Date(timeIntervalSince1970: dateNum)

		default:
			throw MarshalError.typeMismatch(expected: "Date", actual: type(of: object))
		}
	}
}

//	Similar to above
extension Decimal: ValueType {
	public static func value(from object: Any) throws -> Decimal {
		if object is String {
			guard let decimal = NumberFormatter.moneyFormatter.number(from: object as! String)?.decimalValue else {
				throw MarshalError.typeMismatch(expected: "String(DecimalNumber)", actual: object)
			}
			return decimal
		}

		if object is NSDecimalNumber {
			guard let decimalNum = object as? NSDecimalNumber else {
				throw MarshalError.typeMismatch(expected: "DecimalNumber", actual: object)
			}
			return decimalNum.decimalValue
		}

		if object is NSNumber {
			guard let num = object as? NSNumber else {
				throw MarshalError.typeMismatch(expected: "Number", actual: object)
			}
			return num.decimalValue
		}

		guard let decimal = object as? Decimal else {
			throw MarshalError.typeMismatch(expected: "Decimal", actual: object)
		}
		return decimal
	}
}

extension NSDecimalNumber: ValueType {

	public static func value(from object: Any) throws -> NSDecimalNumber {
		if object is String {
			guard let decimal = NumberFormatter.moneyFormatter.number(from: object as! String) as? NSDecimalNumber else {
				throw MarshalError.typeMismatch(expected: "String(NSDecimalNumber)", actual: object)
			}
			return decimal
		}
		if object is NSNumber {
			guard let number = object as? NSNumber else {
				throw MarshalError.typeMismatch(expected: "NSNumber with decimal value", actual: object)
			}
			return NSDecimalNumber(decimal: number.decimalValue)
		}

		guard let decimal = object as? NSDecimalNumber else {
			throw MarshalError.typeMismatch(expected: "NSDecimalNumber", actual: object)
		}
		return decimal
	}
}


