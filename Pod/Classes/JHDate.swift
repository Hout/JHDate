
//
//  NSDateComponents.swift
//  JHCalendar
//
//  Created by Jeroen Houtzager on 12/10/15.
//  Copyright © 2015 Jeroen Houtzager. All rights reserved.
//

/** JHDate is a wrapper around NSDate that exposes the properties of NSDateComponents. Thus offering date functions with a flexibility that I was looking for:
    - Use the object as an NSDate. I.e. as an absolute time.
    - Contains a date (NSDate), a calendar (NSCalendar) and a timeZone (NSTimeZone) property
    - Offers all NSDate & NSDateComponent vars & methods
    - Initialise a date with any combination of components
    - Use default values for initialisation if desired
    - Calendar & time zone can be changed, properties change along
    - Default date is `NSDate()`
    - Default calendar is `NSCalendar.currentCalendar()`
    - Default time zone is `NSTimeZone.localTimeZone()`
    - Implements the Comparable protocol betwen dates with operators. E.g. `==, !=, <, >, <=, >=`
    - implements date addition and subtraction operators with date components. E.g. `date + 2.days`
*/

import Foundation


// MARK: - Initialisations

public class JHDate {

    /// Set to loop throuhg all NSCalendarUnit values
    ///
    private static let componentFlagSet: [NSCalendarUnit] = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekdayOrdinal, .WeekOfMonth]

    /// NSCalendarUnit values used to obtain data from a date with a calendar and time zone
    ///
    private static let componentFlags: NSCalendarUnit = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekOfMonth]
    

    /// NSDate value (i.e. absolute time) around which the JHDate evolves.
    ///
    /// - warning: Please note that the date is immutable alike NSDate. This keeps the main datemvalue of this class thread safe.
    ///     If you want to assign a new value then you must assign it to a new instance of JHDate.
    ///
    public let date: NSDate

    /// Calendar to interpret date values. You can alter the calendar to adjust the representation of date to your needs.
    ///
    public var calendar: NSCalendar

    /// Time zone to interpret date values
    /// Because the time zone is part of calendar, this is a shortcut to that variable.
    /// You can alter the time zone to adjust the representation of date to your needs.
    ///
    public var timeZone: NSTimeZone {
        get {
            return calendar.timeZone
        }
        set {
            calendar.timeZone = newValue
        }
    }

    /// Initialise with a date, a calendar and/or a time zone
    ///
    /// - Parameters:
    ///     - date:       the date to assign, default = NSDate() (that is the current time)
    ///     - calendar:   the calendar to work with to assign, default = the current calendar
    ///     - timeZone:   the time zone to work with, default is the default time zone
    ///
    public init(date aDate: NSDate? = nil, calendar aCalendar: NSCalendar? = nil, timeZone aTimeZone: NSTimeZone? = nil) {
        date = aDate ?? NSDate()
        calendar = aCalendar ?? NSCalendar.currentCalendar()
        timeZone = aTimeZone ?? NSTimeZone.defaultTimeZone()
    }

    /// Create a default date components to use internally with the init with date components
    ///
    /// - Returns: date components that contain the reference date (1 January 2001, midnight in the current time zone)
    ///
    internal class func defaultComponents() -> NSDateComponents {
        let referenceDate = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(0))
        let thisCalendar = NSCalendar.currentCalendar()
        let UTC = NSTimeZone(forSecondsFromGMT: 0)
        thisCalendar.timeZone  = UTC
        let theseComponents = thisCalendar.components(JHDate.componentFlags, fromDate: referenceDate)
        theseComponents.calendar = thisCalendar
        theseComponents.timeZone = NSTimeZone.defaultTimeZone()
        return theseComponents
    }

    /// Initialise with year month day date components
    ///
    /// Parameters are interpreted based on the context of the calendar.
    /// year, month and day are compulsory. The other parameters can be left out
    /// and will default to their values for the reference date.
    ///
    public convenience init?(
        era: Int? = nil,
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil) {

            let defaultComponents = JHDate.defaultComponents()

            let components = NSDateComponents()
            components.era = era ?? defaultComponents.era
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour ?? defaultComponents.hour
            components.minute = minute ?? defaultComponents.minute
            components.second = second ?? defaultComponents.second
            components.nanosecond = nanosecond ?? defaultComponents.nanosecond
            components.timeZone = timeZone ?? defaultComponents.timeZone
            components.calendar = calendar ?? defaultComponents.calendar

            self.init(components: components)
    }

    /// Initialise with week number date components
    ///
    /// Parameters are interpreted based on the context of the calendar.
    /// yearForWeekOfYear, weekOfYear and weekday are compulsory. The other parameters can be left out
    /// and will default to their values for the reference date.
    ///
    public convenience init?(
        era: Int? = nil,
        yearForWeekOfYear: Int,
        weekOfYear: Int,
        weekday: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil) {

            let defaultComponents = JHDate.defaultComponents()

            let components = NSDateComponents()
            components.era = era ?? defaultComponents.era
            components.yearForWeekOfYear = yearForWeekOfYear
            components.weekOfYear = weekOfYear
            components.weekday = weekday
            components.hour = hour ?? defaultComponents.hour
            components.minute = minute ?? defaultComponents.minute
            components.second = second ?? defaultComponents.second
            components.nanosecond = nanosecond ?? defaultComponents.nanosecond
            components.timeZone = timeZone ?? defaultComponents.timeZone
            components.calendar = calendar ?? defaultComponents.calendar

            self.init(components: components)
    }


    /// Initialise with date components
    ///
    /// - Parameters:
    ///     - components: date components according to which the date will be set.
    ///         Default values are these of the reference date.
    ///
    /// - Returns: a new instance of JHDate. If a date cannot be constructed from
    ///         the components, a nil value will be returned.
    ///
    /// - SeeAlso: [dateFromComponents](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDateComponents_Class/)
    ///
    public convenience init?(components: NSDateComponents) {

        let defaultComponents = JHDate.defaultComponents()

        if components.calendar == nil {
            components.calendar = defaultComponents.calendar
        }
        if components.timeZone == nil {
            components.timeZone = NSTimeZone.defaultTimeZone()
            components.calendar!.timeZone = NSTimeZone.defaultTimeZone()
        }

        // One of the year components must be defined to init successful
        if components.year == NSDateComponentUndefined && components.yearForWeekOfYear == NSDateComponentUndefined {
            components.year = defaultComponents.year
        }

        let thisDate = components.calendar!.dateFromComponents(components)
        self.init(date: thisDate, calendar: components.calendar, timeZone: components.timeZone)
    }

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
}

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
    ///     yearForWeekOfYear, weekOfYear, weekday, quarter and weekOfMonth.
    /// Values returned are in the context of the calendar and time zone properties.
    ///
    /// - Returns: An NSDateComponents object containing date decomposed into the components as specified.
    ///
    public var components : NSDateComponents {
        return calendar.components(JHDate.componentFlags, fromDate: date)
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

    /// The number of quarter units for the receiver.
    /// Weekday ordinal units represent the position of the weekday within the next larger calendar unit,
    ///     such as the month. For example, 2 is the weekday ordinal unit for the second Friday of the month.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
   public var quarter: Int? {
        return valueForComponent(.Quarter)
    }

    /// The week number in the month for the receiver.
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public var weekOfMonth: Int? {
        return valueForComponent(.WeekOfMonth)
    }

}

// MARK: - CustomStringConvertable delegate

extension JHDate : CustomStringConvertible {

    /// Returns a full description of the class
    ///
    public var description: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee dd-MMM-yyyy GG HH:mm:ss.SSS zzz"
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.stringFromDate(self.date)
    }

}


// MARK: - start of and end of operations

public extension JHDate {

    /// Takes a date unit and returns the next bigger date unit. 
    /// The returned value normally folows the sequence from hour to year to month etc. 
    /// When submitting a week oriented unit the next week oriented unit will be returned, or era for the yearForWekeOfYear.
    ///
    /// - Parameters:
    ///     - unit: calendrical unit.
    ///
    /// - Returns: calendrical unit which is one step bigger in the calendrical unit system
    ///
    internal func biggerUnit(unit: NSCalendarUnit) -> NSCalendarUnit? {
        switch unit {
        case NSCalendarUnit.Era: return nil
        case NSCalendarUnit.Year: return .Era
        case NSCalendarUnit.Month: return .Year
        case NSCalendarUnit.Day: return .Month
        case NSCalendarUnit.Hour: return .Day
        case NSCalendarUnit.Minute: return .Hour
        case NSCalendarUnit.Second: return .Minute
        case NSCalendarUnit.Nanosecond: return .Second
        case NSCalendarUnit.YearForWeekOfYear: return .Era
        case NSCalendarUnit.WeekOfYear: return .YearForWeekOfYear
        case NSCalendarUnit.Weekday: return .WeekOfYear
        default: return nil
        }
    }

    /// Takes a date unit and returns a set of smaller date units.
    /// The returned value normally follows the sequence from year to month to day to hour etc.
    /// When submitting a week oriented unit the next week oriented unit will be returned, or hour for the weekday.
    ///
    /// - Parameters:
    ///     - unit: calendrical unit.
    ///
    /// - Returns: set of calendrical units which is one step bigger in the calendrical unit system
    ///
    /// - note: Mind that the returned value is a Set as in Collection, not a RawOptionSet
    ///
    internal func smallerUnits(unit: NSCalendarUnit) -> [NSCalendarUnit]? {
        switch unit {
        case NSCalendarUnit.Era: return [.Nanosecond, .Second, .Minute, .Hour, .Day, .Month, .Year]
        case NSCalendarUnit.Year: return [.Nanosecond, .Second, .Minute, .Hour, .Day, .Month]
        case NSCalendarUnit.Month: return [.Nanosecond, .Second, .Minute, .Hour, .Day]
        case NSCalendarUnit.Day: return [.Nanosecond, .Second, .Minute, .Hour]
        case NSCalendarUnit.Hour: return [.Nanosecond, .Second, .Minute]
        case NSCalendarUnit.Minute: return [.Nanosecond, .Second]
        case NSCalendarUnit.Second: return [.Nanosecond]
        case NSCalendarUnit.Nanosecond: return []
        case NSCalendarUnit.YearForWeekOfYear: return [.Nanosecond, .Second, .Minute, .Hour, .Weekday, .WeekOfYear]
        case NSCalendarUnit.WeekOfYear: return [.Nanosecond, .Second, .Minute, .Hour, .Weekday]
        case NSCalendarUnit.Weekday: return [.Nanosecond, .Second, .Minute, .Hour]
        default:
            return nil
        }
    }

    /// Takes a date unit and returns a date at the start of that unit.
    /// E.g. JHDate().startOf(.Year) would return last New Year at midnight.
    ///
    /// - Parameters:
    ///     - unit: calendrical unit.
    ///
    /// - Returns: a date at the start of the unit
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public func startOf(unit: NSCalendarUnit) -> JHDate? {
        let theseComponents = components

        let YMDUnits: NSCalendarUnit = [.Year, .Month, .Day]
        let YWDUnits: NSCalendarUnit = [.YearForWeekOfYear, .WeekOfYear, .Weekday]

        // Remove components that involve cause data that could upset dateFromComponents
        if YMDUnits.contains(unit) {
            theseComponents.yearForWeekOfYear = NSDateComponentUndefined
            theseComponents.weekOfYear = NSDateComponentUndefined
            theseComponents.weekOfMonth = NSDateComponentUndefined
            theseComponents.weekday = NSDateComponentUndefined
            theseComponents.weekdayOrdinal = NSDateComponentUndefined
            theseComponents.quarter = NSDateComponentUndefined
        }

        if YWDUnits.contains(unit) {
            theseComponents.year = NSDateComponentUndefined
            theseComponents.month = NSDateComponentUndefined
            theseComponents.day = NSDateComponentUndefined
            theseComponents.quarter = NSDateComponentUndefined
        }

        for thisUnit in smallerUnits(unit)! {
            let nextBiggerUnit = biggerUnit(thisUnit)!
            let range = calendar.rangeOfUnit(thisUnit, inUnit: nextBiggerUnit, forDate: self.date)
            let minimum = range.location
            theseComponents.setValue(minimum, forComponent:thisUnit)
        }

        let newDate = calendar.dateFromComponents(theseComponents)
        guard newDate != nil else {
            return nil
        }
        return JHDate(date: newDate!, calendar: self.calendar, timeZone: self.timeZone)
    }

    /// Takes a date unit and returns a date at the end of that unit.
    /// E.g. JHDate().endOf(.Year) would return 31 December of this year at 23:59:59.999. 
    /// That is, if a Georgian calendar is used.
    ///
    /// - Parameters:
    ///     - unit: calendrical unit.
    ///
    /// - Returns: a date at the end of the unit
    ///
    /// - note: This value is interpreted in the context of the calendar with which it is used
    ///
    public func endOf(unit: NSCalendarUnit) -> JHDate? {
        let nextDate = calendar.dateByAddingUnit(unit, value: 1, toDate: self.date, options: NSCalendarOptions(rawValue: 0))!
        let nextJHDate = JHDate(date: nextDate, calendar: calendar, timeZone: timeZone)
        let nextDateStart = nextJHDate.startOf(unit)!
        let newDate = calendar.dateByAddingUnit(.Second, value: -1, toDate: nextDateStart.date, options: NSCalendarOptions(rawValue: 0))
        guard newDate != nil else {
            return nil
        }
        return JHDate(date: newDate!, calendar: self.calendar, timeZone: self.timeZone)
    }

}

// MARK: - Comparators

public extension JHDate {

    public func hasTheSame(unitFlags: NSCalendarUnit, asDate date: JHDate) -> Bool {
        for flag in JHDate.componentFlagSet {
            if unitFlags.contains(flag) {
                if self.valueForComponent(flag) != date.valueForComponent(flag) {
                    return false
                }
            }
        }
        return true
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

    /// Returns whether the given date is on a weekday; i.e. it is not in the weekend.
    ///
    /// - Returns: a boolean indicating whether the receiver is on a weekday
    ///
    /// - note: This value is interpreted in the context of the calendar of the receiver
    ///
    /// - seealso: [isDateInWeekend:](xcdoc://?url=developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/instm/NSCalendar/isDateInWeekend:)
    ///
    public func isInWeekday() -> Bool {
        return !self.isInWeekend()
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
    public func isEqualToDate(date: NSDate) -> Bool {
        return calendar.isDate(self.date, inSameDayAsDate: date)
    }

    public func isEqualToDate(date: NSDate, toUnitGranularity unit: NSCalendarUnit) -> Bool {
        return calendar.isDate(self.date, equalToDate: date, toUnitGranularity: unit)
    }
}

// MARK: - Comparable delegate


/// Instances of conforming types can be compared using relational operators, which define a strict total order.
///
/// A type conforming to Comparable need only supply the < and == operators; default implementations of <=, >, >=, and != are supplied by the standard library:
///
extension JHDate : Comparable {}

/// Returns whether the given date is equal to the receiver. 
/// Just the dates are compared. Calendars, time zones are irrelevant.
///
/// - Parameters:
///     - date: a date to compare against
///
/// - Returns: a boolean indicating whether the receiver is equal to the given date
///
public func ==(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.timeIntervalSinceReferenceDate == rdate.timeIntervalSinceReferenceDate
}

/// Returns whether the given date is later than the receiver.
/// Just the dates are compared. Calendars, time zones are irrelevant.
///
/// - Parameters:
///     - date: a date to compare against
///
/// - Returns: a boolean indicating whether the receiver is earlier than the given date
///
public func <(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.timeIntervalSinceReferenceDate < rdate.timeIntervalSinceReferenceDate
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
    return ldate.timeIntervalSinceReferenceDate > rdate.timeIntervalSinceReferenceDate
}


// MARK: - Operators

public extension JHDate {

    /// Returns, as an NSDateComponents object using specified components, the difference between the receiver and the supplied date.
    ///
    /// - Parameters:
    ///     - toDate: a date to calculate against
    ///     - unitFlags: Specifies the components for the returned NSDateComponents object
    ///
    /// - Returns: An NSDateComponents object whose components are specified by unitFlags and 
    ///     calculated from the difference between the resultDate and startDate.
    ///
    /// - note: This value is calculated in the context of the calendar of the receiver
    ///
    public func difference(toDate: NSDate, unitFlags: NSCalendarUnit) -> NSDateComponents? {
        return calendar.components(unitFlags, fromDate: self.date, toDate: toDate, options: NSCalendarOptions(rawValue: 0))
    }

    /// Returns a new NSDate object representing the absolute time calculated by adding given components to the receiver.
    ///
    /// - Parameters:
    ///     - components: the components to add to the receiver
    ///
    /// - Returns: A new NSDate object representing the absolute time calculated by adding to date the calendrical components specified by components.
    ///
    /// - note: This value is calculated in the context of the calendar of the receiver
    ///
    internal func addComponents(components: NSDateComponents) -> JHDate? {
        let newDate = calendar.dateByAddingComponents(components, toDate: self.date, options: NSCalendarOptions.MatchStrictly)
        guard newDate != nil else {
            return nil
        }
        return JHDate(date: newDate!, calendar: self.calendar, timeZone: self.timeZone)
    }
}

/// Returns a new NSDate object representing a new time calculated by subtracting given right hand components from the left hand date.
///
/// - Parameters:
///     - lhs: the date to subtract components from
///     - rhs: the components to subtract from the date
///
/// - Returns: A new NSDate object representing the time calculated by subtracting from date the calendrical components specified by components.
///
/// - note: This value is calculated in the context of the calendar of the date
///
public func - (lhs: JHDate, rhs: NSDateComponents) -> JHDate? {
    return lhs + (-rhs)
}

/// Returns a new NSDate object representing a new time calculated by adding given right hand components to the left hand date.
///
/// - Parameters:
///     - lhs: the date to add the components to
///     - rhs: the components to add to the date
///
/// - Returns: A new NSDate object representing the time calculated by adding to date the calendrical components specified by components.
///
/// - note: This value is calculated in the context of the calendar of the date
///
public func + (lhs: JHDate, rhs: NSDateComponents) -> JHDate? {
    return lhs.addComponents(rhs)
}


/// Returns a new NSDateComponents object representing the negative values of components that are submitted
///
/// - Parameters:
///     - dateComponents: the components to process
///
/// - Returns: A new NSDateComponents object representing the negative values of components that are submitted
///
public prefix func - (dateComponents: NSDateComponents) -> NSDateComponents {
    let result = NSDateComponents()
    for unit in JHDate.componentFlagSet {
        let value = dateComponents.valueForComponent(unit)
        if value != Int(NSDateComponentUndefined) {
            result.setValue(-value, forComponent: unit)
        }
    }
    return result
}

// MARK: - Helpers to enable expressions e.g. date + 1.days - 20.seconds

public extension Int {

    /// Returns a new NSDateComponents object containing the number of nanoseconds as specified by the receiver
    ///
    public var nanoseconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.nanosecond = self
        return dateComponents
    }

    /// Returns a new NSDateComponents object containing the number of seconds as specified by the receiver
    ///
    public var seconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.second = self
        return dateComponents
    }

    /// Returns a new NSDateComponents object containing the number of minutes as specified by the receiver
    ///
    public var minutes: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.minute = self
        return dateComponents
    }

    /// Returns a new NSDateComponents object containing the number of hours as specified by the receiver
    ///
    public var hours: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.hour = self
        return dateComponents
    }

    /// Returns a new NSDateComponents object containing the number of days as specified by the receiver
    ///
    public var days: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.day = self
        return dateComponents
    }

    /// Returns a new NSDateComponents object containing the number of weeks as specified by the receiver
    ///
    public var weeks: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.weekOfYear = self
        return dateComponents
    }

    /// Returns a new NSDateComponents object containing the number of months as specified by the receiver
    ///
    public var months: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.month = self
        return dateComponents
    }
    
    /// Returns a new NSDateComponents object containing the number of years as specified by the receiver
    ///
    public var years: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.year = self
        return dateComponents
    }
}


