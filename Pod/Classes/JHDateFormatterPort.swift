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
    /// - Returns: A date representation of *string* interpreted using the receiver’s current settings.
    ///
    public func toString() -> String? {
        formatter.doesRelativeDateFormatting = false
        return formatter.stringFromDate(date)
    }

    /// Returns a relative date representation of a given string interpreted using the receiver’s current settings. 
    /// If a date formatter uses relative date formatting, where possible it replaces the date component of its 
    /// output with a phrase—such as “today” or “tomorrow”—that indicates a relative date. The available phrases 
    /// depend on the locale for the date formatter; whereas, for dates in the future, English may only allow 
    /// “tomorrow,” French may allow “the day after the day after tomorrow,”.
    ///
    /// - Returns: A relative date representation of *string* interpreted using the receiver’s current settings.
    ///
    public func toRelativeString() -> String? {
        formatter.doesRelativeDateFormatting = true
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