
//
//  NSDateComponents.swift
//  JHCalendar
//
//  Created by Jeroen Houtzager on 12/10/15.
//  Copyright © 2015 Jeroen Houtzager. All rights reserved.
//

/// JHDate is a wrapper around NSDate that exposes the properties of NSDateComponents. Thus offering date functions with a flexibility that I was looking for:
///    - Use the object as an NSDate. I.e. as an absolute time.
///    - Contains a date (NSDate), a calendar (NSCalendar) and a timeZone (NSTimeZone) property
///    - Offers all NSDate & NSDateComponent vars & methods
///    - Initialise a date with any combination of components
///    - Use default values for initialisation if desired
///    - Calendar & time zone can be changed, properties change along
///    - Default date is `NSDate()`
///    - Default calendar is `NSCalendar.currentCalendar()`
///    - Default time zone is `NSTimeZone.localTimeZone()`
///    - Implements the Comparable protocol betwen dates with operators. E.g. `==, !=, <, >, <=, >=`
///    - implements date addition and subtraction operators with date components. E.g. `date + 2.days`

import Foundation

// MARK: - Initialisations

public class JHDate {

    /// Set to loop throuhg all NSCalendarUnit values
    ///
    internal static let componentFlagSet: [NSCalendarUnit] = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekdayOrdinal, .WeekOfMonth]

    /// NSCalendarUnit values used to obtain data from a date with a calendar and time zone
    ///
    internal static let componentFlags: NSCalendarUnit = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekOfMonth]
    

    /// NSDate value (i.e. absolute time) around which the JHDate evolves.
    ///
    /// - warning: Please note that the date is immutable alike NSDate. This keeps the main datemvalue of this class thread safe.
    ///     If you want to assign a new value then you must assign it to a new instance of JHDate.
    ///
    public let date: NSDate

    /// Calendar to interpret date values. You can alter the calendar to adjust the representation of date to your needs.
    ///
    public var calendar: NSCalendar {
        didSet {
            formatter.calendar = calendar
        }
    }

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
            formatter.timeZone = newValue
        }
    }

    /// Locale to interpret date values
    /// Because the locale is part of calendar, this is a shortcut to that variable.
    /// You can alter the locale to adjust the representation of date to your needs.
    ///
    public var locale: NSLocale? {
        get {
            return calendar.locale
        }
        set {
            calendar.locale = newValue
            formatter.locale = newValue
        }
    }

    /// Date formatter to format date values
    ///
    /// - Remarks: Some properties are exposed by the JHDate class. Most of them however,
    ///     should be accessed through the formatter variable. The extra services that
    ///     ``JHDate``provides are management of ``calendar``, ``locale`` and ``timeZone``properties.
    ///
    public let formatter: NSDateFormatter

    /// Initialise with a date, a calendar and/or a time zone
    ///
    /// - Parameters:
    ///     - date:       the date to assign, default = NSDate() (that is the current time)
    ///     - calendar:   the calendar to work with to assign, default = the current calendar
    ///     - timeZone:   the time zone to work with, default is the default time zone
    ///
    public init(date aDate: NSDate? = NSDate(),
        calendar aCalendar: NSCalendar? = NSCalendar.currentCalendar(),
        timeZone aTimeZone: NSTimeZone? = NSTimeZone.defaultTimeZone(),
        locale aLocale: NSLocale? = NSLocale.currentLocale(),
        formatter aFormatter: NSDateFormatter? = NSDateFormatter()) {
            date = aDate!
            calendar = aCalendar!
            formatter = aFormatter!
            timeZone = aTimeZone!
            locale = aLocale
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

