
//
//  NSDateComponents.swift
//  JHCalendar
//
//  Created by Jeroen Houtzager on 12/10/15.
//  Copyright © 2015 Jeroen Houtzager. All rights reserved.
//

// Wrapper around NSDateComponents providing:
// - optional component values
// initialisation with date init functions
// Use case: provide all kind of date information against the current calendar and time zone

import Foundation


// MARK: - Initialisations

public class JHDate : Comparable, CustomStringConvertible {

    // For looping through a set of units
    private static let componentFlagSet: [NSCalendarUnit] = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekdayOrdinal, .WeekOfMonth]

    // For selecting all components from a date
    private static let componentFlags: NSCalendarUnit = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekOfMonth]
    

    public let date: NSDate

    public var calendar: NSCalendar

    public var timeZone: NSTimeZone {
        get {
            return calendar.timeZone
        }
        set {
            calendar.timeZone = newValue
        }
    }

    public init(date aDate: NSDate? = nil, calendar aCalendar: NSCalendar? = nil, timeZone aTimeZone: NSTimeZone? = nil) {
        date = aDate ?? NSDate()
        calendar = aCalendar ?? NSCalendar.currentCalendar()
        timeZone = aTimeZone ?? NSTimeZone.defaultTimeZone()
    }

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

    public class func today() -> JHDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Era, .Year, .Month, .Day, .Calendar, .TimeZone], fromDate: NSDate())
        let date = calendar.dateFromComponents(components)!
        return JHDate(date: date)
    }

    public class func yesterday() -> JHDate {
        return (today() - 1.days)!
    }

    public class func tomorrow() -> JHDate {
        return (today() + 1.days)!
    }

    public func components() -> NSDateComponents {
        return calendar.components(JHDate.componentFlags, fromDate: date)
    }

    public func valueForComponent(flag: NSCalendarUnit) -> Int? {
        let value = calendar.components(flag, fromDate: date).valueForComponent(flag)
        return value == NSDateComponentUndefined ? nil : value
    }

    public func withValue(value: Int, forUnit unit: NSCalendarUnit) -> JHDate? {
        let valueUnits = [(value, unit)]
        return withValues(valueUnits)
    }

    public func withValues(valueUnits: [(Int, NSCalendarUnit)]) -> JHDate? {
        let newComponents = components()
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

    public var era: Int? {
        return valueForComponent(.Era)
    }

    public var year: Int? {
        return valueForComponent(.Year)
    }

    public var month: Int? {
        return valueForComponent(.Month)
    }

    public var day: Int? {
        return valueForComponent(.Day)
    }

    public var hour: Int? {
        return valueForComponent(.Hour)
    }

    public var minute: Int? {
        return valueForComponent(.Minute)
    }

    public var second: Int? {
        return valueForComponent(.Second)
    }

    public var nanosecond: Int? {
        return valueForComponent(.Nanosecond)
    }

    public var yearForWeekOfYear: Int? {
        return valueForComponent(.YearForWeekOfYear)
    }

    public var weekOfYear: Int? {
        return valueForComponent(.WeekOfYear)
    }

    public var weekday: Int? {
        return valueForComponent(.Weekday)
    }

    public var quarter: Int? {
        return valueForComponent(.Quarter)
    }

    public var weekOfMonth: Int? {
        return valueForComponent(.WeekOfMonth)
    }

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

    public func startOf(unit: NSCalendarUnit) -> JHDate? {
        let theseComponents = components()

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

    public func isInToday(  ) -> Bool {
        return calendar.isDateInToday(date)
    }

    public func isInYesterday() -> Bool {
        return calendar.isDateInYesterday(date)
    }

    public func isInTomorrow() -> Bool {
        return calendar.isDateInTomorrow(date)
    }

    public func isInWeekend() -> Bool {
        return calendar.isDateInWeekend(date)
    }

    public func isInWeekday() -> Bool {
        return !self.isInWeekend()
    }

    public func isEqualToDate(date: NSDate) -> Bool {
        return calendar.isDate(self.date, inSameDayAsDate: date)
    }

    public func isEqualToDate(date: NSDate, toUnitGranularity unit: NSCalendarUnit) -> Bool {
        return calendar.isDate(self.date, equalToDate: date, toUnitGranularity: unit)
    }
}

public func ==(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.timeIntervalSinceReferenceDate == rdate.timeIntervalSinceReferenceDate
}


public func <(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.timeIntervalSinceReferenceDate < rdate.timeIntervalSinceReferenceDate
}

public func >(ldate: JHDate, rdate: JHDate) -> Bool {
    return ldate.timeIntervalSinceReferenceDate > rdate.timeIntervalSinceReferenceDate
}




// MARK: - Operators

public extension JHDate {

    public func difference(toDate: NSDate, unitFlags: NSCalendarUnit) -> NSDateComponents? {
        return calendar.components(unitFlags, fromDate: self.date, toDate: toDate, options: NSCalendarOptions(rawValue: 0))
    }

    internal func addComponents(components: NSDateComponents) -> JHDate? {
        let newDate = calendar.dateByAddingComponents(components, toDate: self.date, options: NSCalendarOptions.MatchStrictly)
        guard newDate != nil else {
            return nil
        }
        return JHDate(date: newDate!, calendar: self.calendar, timeZone: self.timeZone)
    }
}

public func - (lhs: JHDate, rhs: NSDateComponents) -> JHDate? {
    return lhs + (-rhs)
}

public func + (lhs: JHDate, rhs: NSDateComponents) -> JHDate? {
    return lhs.addComponents(rhs)
}


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
    public var nanoseconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.nanosecond = self
        return dateComponents
    }
    public var seconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.second = self
        return dateComponents
    }

    public var minutes: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.minute = self
        return dateComponents
    }

    public var hours: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.hour = self
        return dateComponents
    }

    public var days: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.day = self
        return dateComponents
    }

    public var weeks: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.weekOfYear = self
        return dateComponents
    }

    public var months: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.month = self
        return dateComponents
    }
    
    public var years: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.year = self
        return dateComponents
    }
}


