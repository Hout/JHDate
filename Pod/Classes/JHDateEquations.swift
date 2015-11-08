//
//  JHDateComparisons.swift
//  Pods
//
//  Created by Jeroen Houtzager on 26/10/15.
//
//

import Foundation

// MARK: - Equations

public extension JHDate {

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
    public func isEqualToDate(compareDate: JHDate) -> Bool {
        return date.isEqualToDate(compareDate.date)
    }
    
    /// Returns true when the given date is equal to the receiver.
    /// Just the dates are compared. Calendars, time zones are irrelevant.
    ///
    /// - Parameters:
    ///     - date: a date to compare against
    ///
    /// - Returns: a boolean indicating whether the receiver is equal to the given date
    ///
    /// - Remark: This used to be the infix ``func ==``, but since we are subclassing ``NSObject`` now
    ///     we need to resolve this [differently](http://mgrebenets.github.io/swift/2015/06/21/equatable-nsobject-with-swift-2/).
    ///
    override public func isEqual(object: AnyObject?) -> Bool {

        // First check if they are not the same objects
        if super.isEqual(object) {
            return true
        }

        guard object != nil else {
            return false
        }
        let notNilObject = object!

        guard notNilObject.isKindOfClass(JHDate) else {
            return false
        }
        let compareDate = notNilObject as! JHDate

        // Then compare the content, first the date
        guard date.isEqualToDate(compareDate.date) else {
            return false
        }

        // Then the calendar
        guard calendar.calendarIdentifier == compareDate.calendar.calendarIdentifier else {
            return false
        }

        // Then the time zone
        guard timeZone.secondsFromGMTForDate(date) == compareDate.timeZone.secondsFromGMTForDate(compareDate.date) else {
            return false
        }

        // Then the locale
        guard locale.localeIdentifier == compareDate.locale.localeIdentifier else {
            return false
        }

        // We have made it! They are equal!
        return true
    }
}

