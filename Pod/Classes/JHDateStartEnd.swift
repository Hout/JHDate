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
        let components = self.components
        switch unit {
        case NSCalendarUnit.Era:
            components.year = 1
            components.month = 1
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.Year:
            components.month = 1
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.Month:
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.Day, NSCalendarUnit.Weekday:
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.Hour:
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.Minute:
            components.second = 0
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.Second:
            components.nanosecond = 0
            components.yearForWeekOfYear = NSDateComponentUndefined
            components.weekOfYear = NSDateComponentUndefined
            components.weekday = NSDateComponentUndefined
        case NSCalendarUnit.YearForWeekOfYear:
            components.weekOfYear = 1
            components.weekday = calendar.firstWeekday
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.year = NSDateComponentUndefined
            components.month = NSDateComponentUndefined
            components.day = NSDateComponentUndefined
        case NSCalendarUnit.WeekOfYear:
            components.weekday = calendar.firstWeekday
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            components.year = NSDateComponentUndefined
            components.month = NSDateComponentUndefined
            components.day = NSDateComponentUndefined
        default:
            return nil
        }
        return JHDate(components: components)
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
        // Use 10000 nanosecond before the occurrence of the next unit. This is the minimal time difference that
        // is noticed in NSDate.isEqualToDate
        let newDate = calendar.dateByAddingUnit(.Nanosecond, value: -10000, toDate: nextDateStart.date, options: NSCalendarOptions(rawValue: 0))
        guard newDate != nil else {
            return nil
        }
        return JHDate(date: newDate!, calendar: self.calendar, timeZone: self.timeZone)
    }
    
}

