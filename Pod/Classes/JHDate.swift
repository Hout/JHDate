
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


// For looping through a set of units
private let componentFlagSet: [NSCalendarUnit] = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekdayOrdinal, .WeekOfMonth]

// For selecting all components from a date
private let componentFlags: NSCalendarUnit = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar, .YearForWeekOfYear, .WeekOfYear, .Weekday, .Quarter, .WeekOfMonth]


// MARK: - Initialisations

extension NSDate {

    internal class func defaultComponents(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDateComponents {
        let referenceDate = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(0))
        let thisCalendar = calendar.copy() as! NSCalendar
        let UTC = NSTimeZone(forSecondsFromGMT: 0)
        thisCalendar.timeZone  = UTC
        let theseComponents = thisCalendar.components(componentFlags, fromDate: referenceDate)
        theseComponents.calendar = calendar
        theseComponents.timeZone = calendar.timeZone
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

            let theCalendar = calendar ?? NSCalendar.currentCalendar()
            if timeZone != nil {
                theCalendar.timeZone = timeZone!
            }
            let defaultComponents = NSDate.defaultComponents(withCalendar: theCalendar)

            let components = NSDateComponents()
            components.era = era ?? defaultComponents.era
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour ?? defaultComponents.hour
            components.minute = minute ?? defaultComponents.minute
            components.second = second ?? defaultComponents.second
            components.nanosecond = nanosecond ?? defaultComponents.nanosecond
            components.timeZone = theCalendar.timeZone
            components.calendar = theCalendar

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

            let theCalendar = calendar ?? NSCalendar.currentCalendar()
            if timeZone != nil {
                theCalendar.timeZone = timeZone!
            }
            let defaultComponents = NSDate.defaultComponents(withCalendar: theCalendar)

            let components = NSDateComponents()
            components.era = era ?? defaultComponents.era
            components.yearForWeekOfYear = yearForWeekOfYear
            components.weekOfYear = weekOfYear
            components.weekday = weekday
            components.hour = hour ?? defaultComponents.hour
            components.minute = minute ?? defaultComponents.minute
            components.second = second ?? defaultComponents.second
            components.nanosecond = nanosecond ?? defaultComponents.nanosecond
            components.timeZone = theCalendar.timeZone
            components.calendar = theCalendar

            self.init(components: components)
    }


    public convenience init?(components: NSDateComponents, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) {

        if components.calendar == nil {
            components.calendar = calendar
        }
        if components.timeZone == nil {
            components.timeZone = calendar.timeZone
        }
        if components.timeZone == nil {
            components.timeZone = NSTimeZone.defaultTimeZone()
            calendar.timeZone = components.timeZone!
        }

        let defaultComponents = NSDate.defaultComponents(withCalendar: calendar)
        if components.year == NSDateComponentUndefined && components.yearForWeekOfYear == NSDateComponentUndefined { components.year = defaultComponents.year }

        let thisDate = calendar.dateFromComponents(components)
        self.init(timeIntervalSinceReferenceDate: (thisDate?.timeIntervalSinceReferenceDate)!)
    }
}

// MARK: - NSCalendar & NSDateComponent ports


extension NSDate {

    public class func today(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate {
        let components = calendar.components([.Era, .Year, .Month, .Day, .Calendar, .TimeZone], fromDate: NSDate())
        return calendar.dateFromComponents(components)!
    }

    public class func yesterday(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate {
        return (today(withCalendar: calendar) - 1.days)!
    }

    public class func tomorrow(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate {
        return (today(withCalendar: calendar) + 1.days)!
    }

    public func components(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDateComponents {
        return calendar.components(componentFlags, fromDate: self)
    }

    public func valueForComponent(flag: NSCalendarUnit, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        let value = calendar.components(flag, fromDate: self).valueForComponent(flag)
        return value == NSDateComponentUndefined ? nil : value
    }

    public func withValue(value: Int, forUnit unit: NSCalendarUnit, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate? {
        let valueUnits = [(value, unit)]
        return withValues(valueUnits, withCalendar: calendar)
    }

    public func withValues(valueUnits: [(Int, NSCalendarUnit)], withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate? {
        let newComponents = components()
        for valueUnit in valueUnits {
            let value = valueUnit.0
            let unit = valueUnit.1
            newComponents.setValue(value, forComponent: unit)
        }
        return calendar.dateFromComponents(newComponents)!
    }

    public func era(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Era, withCalendar: calendar)
    }

    public func year(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Year, withCalendar: calendar)
    }

    public func month(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Month, withCalendar: calendar)
    }

    public func day(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Day, withCalendar: calendar)
    }

    public func hour(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Hour, withCalendar: calendar)
    }

    public func minute(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Minute, withCalendar: calendar)
    }

    public func second(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Second, withCalendar: calendar)
    }

    public func nanosecond(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Nanosecond, withCalendar: calendar)
    }

    public func yearForWeekOfYear(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.YearForWeekOfYear, withCalendar: calendar)
    }

    public func weekOfYear(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.WeekOfYear, withCalendar: calendar)
    }

    public func weekday(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Weekday, withCalendar: calendar)
    }

    public func quarter(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.Quarter, withCalendar: calendar)
    }

    public func weekOfMonth(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int? {
        return valueForComponent(.WeekOfMonth, withCalendar: calendar)
    }

    public func timeZone() -> NSTimeZone {
        return calendar().timeZone
    }

    public func calendar() -> NSCalendar {
        return NSCalendar.currentCalendar()
    }

    public func toString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee dd-MMM-yy GG HH:mm:ss.SSS zzz"
        dateFormatter.calendar = calendar()
        dateFormatter.timeZone = timeZone()
        return dateFormatter.stringFromDate(self)
    }

}


// MARK: - start of and end of operations

extension NSDate {

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

    public func startOf(unit: NSCalendarUnit) -> NSDate? {
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
            let range = calendar().rangeOfUnit(thisUnit, inUnit: nextBiggerUnit, forDate: self)
            let minimum = range.location
            theseComponents.setValue(minimum, forComponent:thisUnit)
        }

        let newDate = calendar().dateFromComponents(theseComponents)
        return newDate
    }

    public func endOf(unit: NSCalendarUnit) -> NSDate? {
        let nextDate = calendar().dateByAddingUnit(unit, value: 1, toDate: self, options: NSCalendarOptions(rawValue: 0))!
        let nextDateStart = nextDate.startOf(unit)!
        let result = calendar().dateByAddingUnit(.Second, value: -1, toDate: nextDateStart, options: NSCalendarOptions(rawValue: 0))
        return result
    }

}

// MARK: - Comparators

extension NSDate : Comparable {

    public func hasTheSame(unitFlags: NSCalendarUnit, asDate date: NSDate, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        for flag in componentFlagSet {
            if unitFlags.contains(flag) {
                if self.valueForComponent(flag) != date.valueForComponent(flag) {
                    return false
                }
            }
        }
        return true
    }

    public func isInToday(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return calendar.isDateInToday(self)
    }

    public func isInYesterday(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return calendar.isDateInYesterday(self)
    }

    public func isInTomorrow(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return calendar.isDateInTomorrow(self)
    }

    public func isInWeekend(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return calendar.isDateInWeekend(self)
    }

    public func isInWeekday(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return !self.isInWeekend(withCalendar: calendar)
    }

    public func isEqualToDate(date: NSDate, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return calendar.isDate(self, inSameDayAsDate: date)
    }

    public func isEqualToDate(date: NSDate, toUnitGranularity unit: NSCalendarUnit, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Bool {
        return calendar.isDate(self, equalToDate: date, toUnitGranularity: unit)
    }
}


public func <(ldate: NSDate, rdate: NSDate) -> Bool {
    return ldate.timeIntervalSinceReferenceDate < rdate.timeIntervalSinceReferenceDate
}


// MARK: - Operators

extension NSDate {

    internal func difference(toDate: NSDate, unitFlags: NSCalendarUnit, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDateComponents? {
        return calendar.components(unitFlags, fromDate: self, toDate: toDate, options: NSCalendarOptions(rawValue: 0))
    }

    internal func addComponents(components: NSDateComponents, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate? {
        return calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions.MatchStrictly)
    }
}

public func - (lhs: NSDate, rhs: NSDateComponents) -> NSDate? {
    return lhs + (-rhs)
}

public func + (lhs: NSDate, rhs: NSDateComponents) -> NSDate? {
    return lhs.addComponents(rhs)
}


public prefix func - (dateComponents: NSDateComponents) -> NSDateComponents {
    let result = NSDateComponents()
    for unit in componentFlagSet {
        let value = dateComponents.valueForComponent(unit)
        if value != Int(NSDateComponentUndefined) {
            result.setValue(-value, forComponent: unit)
        }
    }
    return result
}

// MARK: - Helpers to enable expressions e.g. date + 1.days - 20.seconds

extension Int {
    var nanoseconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.nanosecond = self
        return dateComponents
    }
    var seconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.second = self
        return dateComponents
    }

    var minutes: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.minute = self
        return dateComponents
    }

    var hours: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.hour = self
        return dateComponents
    }

    var days: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.day = self
        return dateComponents
    }

    var weeks: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.weekOfYear = self
        return dateComponents
    }

    var months: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.month = self
        return dateComponents
    }
    
    var years: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.year = self
        return dateComponents
    }
}


