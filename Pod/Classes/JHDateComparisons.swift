//
//  JHDateComparisons.swift
//  Pods
//
//  Created by Jeroen Houtzager on 26/10/15.
//
//

import Foundation

// MARK: - Comparators

public extension JHDate {

    /// Returns an NSComparisonResult value that indicates the ordering of two given dates based on their components down to a given unit granularity.
    ///
    /// - Parameters:
    ///     - date: date to compare.
    ///     - toUnitGranularity: The smallest unit that must, along with all larger units, be equal for the given dates to be considered the same.
    ///         For possible values, see “[Calendar Units](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/c/tdef/NSCalendarUnit)”
    ///
    /// - Returns: NSOrderedSame if the dates are the same down to the given granularity, otherwise NSOrderedAscending or NSOrderedDescending.
    ///
    /// - seealso: [compareDate:toDate:toUnitGranularity:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/compareDate:toDate:toUnitGranularity:)
    ///
    public func compareDate(date: JHDate, toUnitGranularity unit: NSCalendarUnit) -> NSComparisonResult {
        return calendar.compareDate(self.date, toDate: date.date, toUnitGranularity: unit)
    }

    /// Returns whether the given date is in today.
    ///
    /// - Returns: a boolean indicating whether the receiver is in today
    ///
    /// - note: This value is interpreted in the context of the calendar of the receiver
    ///
    /// - seealso: [isDateInToday:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/isDateInToday:)
    ///
    public func isInToday(  ) -> Bool {
        return calendar.isDateInToday(date)
    }

    /// Returns whether the given date is in yesterday.
    ///
    /// - Returns: a boolean indicating whether the receiver is in yesterday
    ///
    /// - note: This value is interpreted in the context of the calendar of the receiver
    ///
    /// - seealso: [isDateInYesterday:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/isDateInYesterday:)
    ///
    public func isInYesterday() -> Bool {
        return calendar.isDateInYesterday(date)
    }

    /// Returns whether the given date is in tomorrow.
    ///
    /// - Returns: a boolean indicating whether the receiver is in tomorrow
    ///
    /// - note: This value is interpreted in the context of the calendar of the receiver
    ///
    /// - seealso: [isDateInTomorrow:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/isDateInTomorrow:)
    ///
    public func isInTomorrow() -> Bool {
        return calendar.isDateInTomorrow(date)
    }

    /// Returns whether the given date is in the weekend.
    ///
    /// - Returns: a boolean indicating whether the receiver is in the weekend
    ///
    /// - note: This value is interpreted in the context of the calendar of the receiver
    ///
    /// - seealso: [isDateInWeekend:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/isDateInWeekend:)
    ///
    public func isInWeekend() -> Bool {
        return calendar.isDateInWeekend(date)
    }

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

// MARK: - Comparable delegate


/// Instances of conforming types can be compared using relational operators, which define a strict total order.
///
/// A type conforming to Comparable need only supply the < and == operators; default implementations of <=, >, >=, and != are supplied by the standard library:
///
extension JHDate : Comparable {}

/// Returns whether the given date is later than the receiver.
/// Just the dates are compared. Calendars, time zones are irrelevant.
///
/// - Parameters:
///     - date: a date to compare against
///
/// - Returns: a boolean indicating whether the receiver is earlier than the given date
///
public func <(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.date.compare(rdate.date) == .OrderedAscending
}

/// Returns whether the given date is earlier than the receiver.
/// Just the dates are compared. Calendars, time zones are irrelevant.
///
/// - Parameters:
///     - date: a date to compare against
///
/// - Returns: a boolean indicating whether the receiver is later than the given date
///
public func >(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.date.compare(rdate.date) == .OrderedDescending
}


