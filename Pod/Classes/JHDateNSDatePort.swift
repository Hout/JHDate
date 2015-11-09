//
//  JHDateNSDatePort.swift
//  Pods
//
//  Created by Jeroen Houtzager on 02/11/15.
//
//

import Foundation

extension JHDate {

    /// Time interval since the reference date at 1 January 2001
    ///
    /// - Returns: the number of seconds as an NSTimeInterval.
    ///
    /// - SeeAlso: [timeIntervalSinceReferenceDate](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDate_Class/#//apple_ref/occ/instp/NSDate/timeIntervalSinceReferenceDate)
    ///
    public var timeIntervalSinceReferenceDate: NSTimeInterval {

        // Reference date = midnight at 1 January 2001 in the local time zone
        let theseComponents = NSDateComponents()
        theseComponents.year = 2001
        theseComponents.month = 1
        theseComponents.day = 1
        theseComponents.calendar = calendar
        theseComponents.timeZone = timeZone

        let referenceDate = calendar.dateFromComponents(theseComponents)!

        return date.timeIntervalSinceReferenceDate - referenceDate.timeIntervalSinceReferenceDate
    }

    /// Creates and returns a JHDate object representing a date in the distant past (in terms of centuries).
    ///
    /// - Returns: A ``JHDate`` object representing a date in the distant past (in terms of centuries).
    ///
    public static func distantFuture() -> JHDate {
        return JHDate(date: NSDate.distantFuture())
    }

    /// Creates and returns a JHDate object representing a date in the distant future (in terms of centuries).
    ///
    /// - Returns: A ``JHDate`` object representing a date in the distant future (in terms of centuries).
    ///
    public static func distantPast() -> JHDate {
        return JHDate(date: NSDate.distantPast())
    }

    /// Returns a JHDate object representing a date that is the earliest from a given range of dates.
    /// The dates are compared in absolute time, i.e. time zones, locales and calendars have no effect
    /// on the comparison.
    ///
    /// - Parameters:
    ///     - dates: a number of dates to be evaluated
    ///
    /// - Returns: a ``JHDate`` object representing a date that is the earliest from a given range of dates.
    ///
    public static func earliestDate(dates: JHDate ...) -> JHDate {
        var currentMinimum = JHDate.distantFuture()
        for thisDate in dates {
            if currentMinimum > thisDate {
                currentMinimum = thisDate
            }
        }
        return currentMinimum
    }

    /// Returns a JHDate object representing a date that is the latest from a given range of dates.
    /// The dates are compared in absolute time, i.e. time zones, locales and calendars have no effect
    /// on the comparison.
    ///
    /// - Parameters:
    ///     - dates: a number of dates to be evaluated
    ///
    /// - Returns: a ``JHDate`` object representing a date that is the latest from a given range of dates.
    ///
    public static func latestDate(dates: JHDate ...) -> JHDate {
        var currentMaximum = JHDate.distantPast()
        for thisDate in dates {
            if currentMaximum < thisDate {
                currentMaximum = thisDate
            }
        }
        return currentMaximum
    }

}