//
//  JHDateFormatterPort.swift
//  Pods
//
//  Created by Jeroen Houtzager on 01/11/15.
//
//

import Foundation

// MARK: - NSDateFormatter port

public extension JHDate {

    /// Returns a date representation of a given string interpreted using the receiver’s current settings.
    ///
    /// - Parameters:
    ///     - string: The string to parse.
    ///
    /// - Returns: A date representation of *string* interpreted using the receiver’s current settings.
    /// If ``dateFromString:`` can not parse the string, returns ``nil``.
    ///
    public func toString() -> String? {
        return formatter.stringFromDate(date)
    }

    /// The default date for the formatter
    ///
    public var dateFormat: String {
        get {
            return formatter.dateFormat
        }
        set {
            formatter.dateFormat = newValue
        }
    }

    /// The date style for the formatter
    ///
    public var dateStyle: NSDateFormatterStyle {
        get {
            return formatter.dateStyle
        }
        set {
            formatter.dateStyle = newValue
        }
    }

    /// The time style for the formatter
    ///
    public var timeStyle: NSDateFormatterStyle {
        get {
            return formatter.timeStyle
        }
        set {
            formatter.timeStyle = newValue
        }
    }

}