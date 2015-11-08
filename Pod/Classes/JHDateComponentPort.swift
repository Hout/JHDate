//
//  JHDatePortFunc.swift
//  Pods
//
//  Created by Jeroen Houtzager on 26/10/15.
//
//

import Foundation


// MARK: - NSCalendar & NSDateComponent ports

public extension JHDate {

    /// Today's date
    ///
    /// - Returns: the date of today at midnight (00:00) in the current calendar and default time zone.
    ///
    public class func today() -> JHDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Era, .Year, .Month, .Day, .Calendar, .TimeZone], fromDate: NSDate())
        let date = calendar.dateFromComponents(components)!
        return JHDate(date: date)
    }

    /// Yesterday's date
    ///
    /// - Returns: the date of yesterday at midnight (00:00) in the current calendar and default time zone.
    ///
    public class func yesterday() -> JHDate {
        return (today() - 1.days)!
    }

    /// Tomorrow's date
    ///
    /// - Returns: the date of tomorrow at midnight (00:00) in the current calendar and default time zone.
    ///
    public class func tomorrow() -> JHDate {
        return (today() + 1.days)!
    }

    /// Returns a NSDateComponents object containing a given date decomposed into components:
    ///     day, month, year, hour, minute, second, nanosecond, timeZone, calendar,
    ///     yearForWeekOfYear, weekOfYear, weekday<s>, quarter</s> and weekOfMonth.
    /// Values returned are in the context of the calendar and time zone properties.
    ///
    /// - Returns: An NSDateComponents object containing date decomposed into the components as specified.
    ///
    public var components : NSDateComponents {
        return calendar.components(JHDate.componentFlags, fromDate: self.date)
    }

    /// Returns the value for an NSDateComponents object.
    /// Values returned are in the context of the calendar and time zone properties.
    ///
    /// - Parameters:
    ///     - flag: specifies the calendrical unit that should be returned
    ///
    /// - Returns: The value of the NSDateComponents object for the date.
    public func valueForComponent(flag: NSCalendarUnit) -> Int? {
        let value = calendar.components(flag, fromDate: date).valueForComponent(flag)
        return value == NSDateComponentUndefined ? nil : value
    }

    /// Returns a new JHDate object with self as base value and a value for a NSDateComponents object set.
    ///
    /// - Parameters:
    ///     - value: value to be set for the unit
    ///     - unit: specifies the calendrical unit that should be set
    ///
    /// - Returns: A new JHDate object with self as base and a specific component value set.
    ///     If no date can be constructed from the value given, a nil will be returned
    ///
    /// - seealso: public func withValues(valueUnits: [(Int, NSCalendarUnit)]) -> JHDate?
    ///
    public func withValue(value: Int, forUnit unit: NSCalendarUnit) -> JHDate? {
        let valueUnits = [(value, unit)]
        return withValues(valueUnits)
    }

    /// Returns a new JHDate object with self as base value and a value for a NSDateComponents object set.
    ///
    /// - Parameters:
    ///     - valueUnits: a set of tupels of values and units to be set
    ///
    /// - Returns: A new JHDate object with self as base and the component values set.
    ///     If no date can be constructed from the values given, a nil will be returned
    ///
    /// - seealso: public func withValues(valueUnits: [(Int, NSCalendarUnit)]) -> JHDate?
    ///
    public func withValues(valueUnits: [(Int, NSCalendarUnit)]) -> JHDate? {
        let newComponents = components
        for valueUnit in valueUnits {
            let value = valueUnit.0
            let unit = valueUnit.1
            newComponents.setValue(value, forComponent: unit)
        }
        let newDate = calendar.dateFromComponents(newComponents)
        guard newDate != nil else {
            return nil
        }
        return JHDate(date: newDate!, calendar: self.calendar, timeZone: self.timeZone)
    }

    /// The number of era units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var era: Int? {
        return valueForComponent(.Era)
    }

    /// The number of year units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var year: Int? {
        return valueForComponent(.Year)
    }

    /// The number of month units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var month: Int? {
        return valueForComponent(.Month)
    }

    /// The number of day units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var day: Int? {
        return valueForComponent(.Day)
    }

    /// The number of hour units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var hour: Int? {
        return valueForComponent(.Hour)
    }

    /// The number of minute units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var minute: Int? {
        return valueForComponent(.Minute)
    }

    /// The number of second units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var second: Int? {
        return valueForComponent(.Second)
    }

    /// The number of nanosecond units for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var nanosecond: Int? {
        return valueForComponent(.Nanosecond)
    }

    /// The ISO 8601 week-numbering year of the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var yearForWeekOfYear: Int? {
        return valueForComponent(.YearForWeekOfYear)
    }

    /// The ISO 8601 week date of the year for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var weekOfYear: Int? {
        return valueForComponent(.WeekOfYear)
    }

    /// The number of weekday units for the receiver.
    /// Weekday units are the numbers 1 through n, where n is the number of days in the week.
    /// For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var weekday: Int? {
        return valueForComponent(.Weekday)
    }

    /// The ordinal number of weekday units for the receiver.
    /// Weekday ordinal units represent the position of the weekday within the next larger calendar unit,
    ///     such as the month. For example, 2 is the weekday ordinal unit for the second Friday of the month.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var weekdayOrdinal: Int? {
        return valueForComponent(.WeekdayOrdinal)
    }

    /** QUARTER IS NOT INCLUDED DUE TO INCORRECT REPRESENTATION OF QUARTER IN NSCALENDAR
    /// The number of quarter units for the receiver.
    /// Weekday ordinal units represent the position of the weekday within the next larger calendar unit,
    ///     such as the month. For example, 2 is the weekday ordinal unit for the second Friday of the month.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var quarter: Int? {
        return valueForComponent(.Quarter)
    }
    **/

    /// The week number in the month for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var weekOfMonth: Int? {
        return valueForComponent(.WeekOfMonth)
    }

    /// Boolean value that indicates whether the month is a leap month.
    /// ``YES`` if the month is a leap month, ``NO`` otherwise
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var leapMonth: Bool {
        // Library function for leap contains a bug for Gregorian calendars, implemented workaround
        if calendar.calendarIdentifier == NSCalendarIdentifierGregorian && year >= 1582 {
            let range = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
            return range.length == 29
        }

        // For other calendars:
        return calendar.components([.Day, .Month, .Year], fromDate: date).leapMonth
    }

    /// Boolean value that indicates whether the year is a leap year.
    /// ``YES`` if the year is a leap year, ``NO`` otherwise
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var leapYear: Bool {
        // Library function for leap contains a bug for Gregorian calendars, implemented workaround
        if calendar.calendarIdentifier == NSCalendarIdentifierGregorian {
            let testDate = JHDate(refDate: self, month: 2, day: 1)!
            return testDate.leapMonth
        }

        // For other calendars:
        return calendar.components([.Day, .Month, .Year], fromDate: date).leapMonth
    }

}