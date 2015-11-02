
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

public class JHDate : NSObject {

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
    public let calendar: NSCalendar

    /// Time zone to interpret date values
    /// Because the time zone is part of calendar, this is a shortcut to that variable.
    /// You can alter the time zone to adjust the representation of date to your needs.
    ///
    public let timeZone: NSTimeZone

    /// Locale to interpret date values
    /// Because the locale is part of calendar, this is a shortcut to that variable.
    /// You can alter the locale to adjust the representation of date to your needs.
    ///
    public let locale: NSLocale

    /// Initialise with a date, a calendar and/or a time zone
    ///
    /// - Parameters:
    ///     - date:       the date to assign, default = NSDate() (that is the current time)
    ///     - calendar:   the calendar to work with to assign, default = the current calendar
    ///     - timeZone:   the time zone to work with, default is the default time zone
    ///
    public init(date aDate: NSDate? = nil,
        calendar aCalendar: NSCalendar? = nil,
        timeZone aTimeZone: NSTimeZone? = nil,
        locale aLocale: NSLocale? = nil) {
            date = aDate ?? NSDate()
            calendar = aCalendar ?? NSCalendar.currentCalendar()
            timeZone = aTimeZone ?? NSTimeZone.defaultTimeZone()
            locale = aLocale ?? aCalendar?.locale ?? NSLocale.currentLocale()

            super.init()

            // Assign calendar fields
            calendar.timeZone = timeZone
            calendar.locale = locale
    }
    
    
    /// Create a copy JHDate
    ///
    /// - Parameters:
    ///     - date:       the date to assign, default = NSDate() (that is the current time)
    ///     - calendar:   the calendar to work with to assign, default = the current calendar
    ///     - timeZone:   the time zone to work with, default is the default time zone
    ///     - locale:     the locale to work with, default is the current locale
    ///
    public convenience init(copyDate: JHDate) {
        self.init(date: copyDate.date, calendar: copyDate.calendar, timeZone: copyDate.timeZone, locale: copyDate.locale)
    }

    /// Initialise with a date, a calendar and/or a time zone
    ///
    /// - Parameters:
    ///     - date:       the date to assign, default = NSDate() (that is the current time)
    ///     - calendar:   the calendar to work with to assign, default = the current calendar
    ///     - timeZone:   the time zone to work with, default is the default time zone
    ///
    public convenience init?(refDate: JHDate,
        era: Int? = nil,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        yearForWeekOfYear: Int? = nil,
        weekOfYear: Int? = nil,
        weekday: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        calendar: NSCalendar? = nil,
        timeZone: NSTimeZone? = nil,
        locale: NSLocale? = nil) {

            let theCalendar = calendar ?? refDate.calendar ?? NSCalendar.currentCalendar()
            if let newTimeZone = timeZone { theCalendar.timeZone = newTimeZone }
            if let newLocale = locale { theCalendar.locale = newLocale }

            // get components from reference date in new calendar
            let components = theCalendar.components(JHDate.componentFlags, fromDate: refDate.date)
            if let newEra = era { components.era = newEra }
            if let newYear = year { components.year = newYear }
            if let newMonth = month { components.month = newMonth }
            if let newDay = day { components.day = newDay }
            if let newYearForWeekOfYear = yearForWeekOfYear { components.yearForWeekOfYear = newYearForWeekOfYear }
            if let newWeekOfYear = weekOfYear { components.weekOfYear = newWeekOfYear }
            if let newWeekday = weekday { components.weekday = newWeekday }
            if let newHour = hour { components.hour = newHour }
            if let newMinute = minute { components.minute = newMinute }
            if let newSecond = second { components.second = newSecond }
            if let newNanosecond = nanosecond { components.nanosecond = newNanosecond }
            components.calendar = theCalendar
            components.timeZone = theCalendar.timeZone
            
            // determine way of conversion: year month day or year week weekday
            var ymdFactor = 0
            if components.year != NSDateComponentUndefined { ymdFactor++ }
            if components.month != NSDateComponentUndefined { ymdFactor++ }
            if components.day != NSDateComponentUndefined { ymdFactor++ }

            var ywwFactor = 0
            if components.yearForWeekOfYear != NSDateComponentUndefined { ywwFactor++ }
            if components.weekOfYear != NSDateComponentUndefined { ywwFactor++ }
            if components.weekday != NSDateComponentUndefined { ywwFactor++ }

            if ywwFactor > ymdFactor {
                components.year = NSDateComponentUndefined
                components.month = NSDateComponentUndefined
                components.day = NSDateComponentUndefined
            } else if ymdFactor > 0 {
                components.yearForWeekOfYear = NSDateComponentUndefined
                components.weekOfYear = NSDateComponentUndefined
                components.weekday = NSDateComponentUndefined
            }

            self.init(components: components, locale: locale)
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
    public convenience init?(
        components: NSDateComponents,
        locale aLocale: NSLocale? = nil) {

            let theCalendar = components.calendar ?? NSCalendar.currentCalendar()
            let thisDate = theCalendar.dateFromComponents(components)
            guard thisDate != nil else {
                return nil
            }
            self.init(date: thisDate, calendar: components.calendar, timeZone: components.timeZone, locale: aLocale)
    }
    

    /// Initialise with year month day date components
    ///
    /// Parameters are interpreted based on the context of the calendar.
    /// year, month and day are compulsory. The other parameters can be left out
    /// and will default to their values for the reference date.
    ///
    public convenience init?(
        era: Int? = nil,
        year: Int? = nil,
        month: Int? = nil,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil,
        locale aLocale: NSLocale? = nil) {

            let defaultComponents = JHDate.defaultComponents()

            let components = NSDateComponents()
            components.era = era ?? defaultComponents.era ?? NSDateComponentUndefined
            components.year = year ?? defaultComponents.year ?? NSDateComponentUndefined
            components.month = month ?? defaultComponents.month ?? NSDateComponentUndefined
            components.day = day
            components.hour = hour ?? defaultComponents.hour ?? NSDateComponentUndefined
            components.minute = minute ?? defaultComponents.minute ?? NSDateComponentUndefined
            components.second = second ?? defaultComponents.second ?? NSDateComponentUndefined
            components.nanosecond = nanosecond ?? defaultComponents.nanosecond ?? NSDateComponentUndefined
            components.timeZone = timeZone ?? defaultComponents.timeZone
            components.calendar = calendar ?? defaultComponents.calendar

            self.init(components: components, locale: aLocale)
    }
    
    
    /// Initialise with yearForWeekOfYear week weekday date components
    ///
    /// Parameters are interpreted based on the context of the calendar.
    /// year, month and day are compulsory. The other parameters can be left out
    /// and will default to their values for the reference date.
    ///
    public convenience init?(
        era: Int? = nil,
        yearForWeekOfYear: Int? = nil,
        weekOfYear: Int? = nil,
        weekday: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil,
        locale aLocale: NSLocale? = nil) {

            let defaultComponents = JHDate.defaultComponents()

            let components = NSDateComponents()
            components.era = era ?? defaultComponents.era ?? NSDateComponentUndefined
            components.yearForWeekOfYear = yearForWeekOfYear ?? defaultComponents.yearForWeekOfYear ?? NSDateComponentUndefined
            components.weekOfYear = weekOfYear ?? defaultComponents.weekOfYear ?? NSDateComponentUndefined
            components.weekday = weekday
            components.hour = hour ?? defaultComponents.hour ?? NSDateComponentUndefined
            components.minute = minute ?? defaultComponents.minute ?? NSDateComponentUndefined
            components.second = second ?? defaultComponents.second ?? NSDateComponentUndefined
            components.nanosecond = nanosecond ?? defaultComponents.nanosecond ?? NSDateComponentUndefined
            components.timeZone = timeZone ?? defaultComponents.timeZone
            components.calendar = calendar ?? defaultComponents.calendar

            self.init(components: components, locale: aLocale)
    }
    
    
    // NSCoding initialiser
    //
    public required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObjectOfClass(NSDate.self, forKey: "date")!
        calendar = aDecoder.decodeObjectOfClass(NSCalendar.self, forKey: "calendar")!
        timeZone = aDecoder.decodeObjectOfClass(NSTimeZone.self, forKey: "timeZone")!
        locale = aDecoder.decodeObjectOfClass(NSLocale.self, forKey: "locale")!
    }


    // NSCoding coder
    //
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(calendar, forKey: "calendar")
        aCoder.encodeObject(timeZone, forKey: "timeZone")
        aCoder.encodeObject(locale, forKey: "locale")
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

