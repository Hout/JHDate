//
//  JHDateStartEnd.swift
//  Pods
//
//  Created by Jeroen Houtzager on 26/10/15.
//
//

import Foundation

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

