//
//  JHDateComparisons.swift
//  Pods
//
//  Created by Jeroen Houtzager on 26/10/15.
//
//

import Foundation

// MARK: - Equations

extension JHDate : Equatable {}


/// Returns true when the given date is equal to the receiver.
/// Just the dates are compared. Calendars, time zones are irrelevant.
///
/// - Parameters:
///     - date: a date to compare against
///
/// - Returns: a boolean indicating whether the receiver is equal to the given date
///
public func ==(left: JHDate, right: JHDate) -> Bool {

    // Compare the content, first the date
    guard left.date.isEqualToDate(right.date) else {
        return false
    }

    // Then the calendar
    guard left.calendar.calendarIdentifier == right.calendar.calendarIdentifier else {
        return false
    }

    // Then the time zone
    guard left.timeZone.secondsFromGMTForDate(left.date) == right.timeZone.secondsFromGMTForDate(right.date) else {
        return false
    }

    // Then the locale
    guard left.locale.localeIdentifier == right.locale.localeIdentifier else {
        return false
    }

    // We have made it! They are equal!
    return true
}

extension JHDate {

    /// Returns whether the given date is on the same day as the receiver.
    ///
    /// - Parameters:
    ///     - date: a date to compare against
    ///
    /// - Returns: a boolean indicating whether the receiver is on the same day as the given date
    ///
    /// - note: This value is interpreted in the context of the calendar of the receiver
    ///
    /// - seealso: [isDate:inSameDayAsDate:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/isDate:inSameDayAsDate:)
    ///
    public func inSameDayAsDate(date: NSDate) -> Bool {
        return calendar.isDate(self.date, inSameDayAsDate: date)
    }

    /// Returns whether the given date is equal to the receiver.
    ///
    /// - Parameters:
    ///     - date: a date to compare against
    ///
    /// - Returns: a boolean indicating whether the receiver is equal to the given date
    ///
    /// - seealso: [isEqualToDate:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSDate_Class/index.html#//apple_ref/occ/instm/NSDate/isEqualToDate:)
    ///
    public func isEqualToDate(right: JHDate) -> Bool {
        return date.isEqualToDate(right.date)
    }
    
}

