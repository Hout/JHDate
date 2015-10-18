
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
let componentFlagSet: [NSCalendarUnit] = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .YearForWeekOfYear, .WeekOfYear, .Weekday]

// For selecting all components from a date
let componentFlags: NSCalendarUnit = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar, .YearForWeekOfYear, .WeekOfYear, .Weekday]

// For selecting normal year month day components from a date
let componentFlagsYMD: NSCalendarUnit = [.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar]

// For selecting week oriented components from a date
let componentFlagsYWD: NSCalendarUnit = [.Hour, .Minute, .Second, .Nanosecond, .TimeZone, .Calendar, .YearForWeekOfYear, .WeekOfYear, .Weekday]

public class JHDate : Comparable {

    public var components: NSDateComponents
    public var strictEvaluation: Bool = false

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(
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
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil,
        strictEvaluation: Bool = false) {

            self.components = NSDateComponents()
            self.year = year
            self.month = month
            self.day = day
            self.hour = hour
            self.minute = minute
            self.second = second
            self.nanosecond = nanosecond
            self.yearForWeekOfYear = yearForWeekOfYear
            self.weekOfYear = weekOfYear
            self.weekday = weekday
            self.timeZone = timeZone
            self.calendar = calendar
            self.strictEvaluation = strictEvaluation
    }
    
    
    public convenience init(
        timeSinceReferenceDate: NSTimeInterval,
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil,
        strictEvaluation: Bool = false) {
            let date = NSDate(timeIntervalSinceReferenceDate: timeSinceReferenceDate)
            self.init(date: date, calendar: calendar, timeZone: timeZone)
    }

    public convenience init(
        components: NSDateComponents,
        strictEvaluation: Bool = false) {
            self.init()
            for unit in componentFlagSet {
                let value = components.valueForComponent(unit)
                if value != NSDateComponentUndefined {
                    self.components.setValue(value, forComponent: unit)
                }
            }
            self.components.calendar = components.calendar
            self.components.timeZone = components.timeZone
    }

    public convenience init(
        date: NSDate,
        timeZone: NSTimeZone? = nil,
        calendar: NSCalendar? = nil,
        strictEvaluation: Bool = false) {
            let theCalendar = calendar ?? NSCalendar.currentCalendar()
            theCalendar.timeZone = timeZone ?? NSTimeZone.defaultTimeZone()
            let components = theCalendar.components(componentFlags, fromDate: date)
            self.init(components: components, strictEvaluation: strictEvaluation)
    }

    public convenience init(date: JHDate) {
        self.init(components: date.components)
        strictEvaluation = date.strictEvaluation
    }

    public class func now(timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> JHDate {
        let now = NSDate()
        let theCalendar = calendar ?? NSCalendar.currentCalendar()
        let theTimeZone = timeZone ?? NSTimeZone.defaultTimeZone()
        theCalendar.timeZone = theTimeZone
        let components = theCalendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Calendar, .TimeZone], fromDate: now)
        let date = JHDate(components: components)
        return date
    }

    public class func today() -> JHDate {
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Calendar, .TimeZone], fromDate: now)
        let date = JHDate(components: components)
        return date
    }

}

public extension JHDate {

    func filterUnits(units: NSCalendarUnit) -> JHDate {
        let newDate = JHDate(date: self)
        for unit in componentFlagSet {
            let value = units.contains(unit) ? components.valueForComponent(unit) : NSDateComponentUndefined
            newDate.components.setValue(value, forComponent: unit)
        }
        newDate.calendar = units.contains(.Calendar) ? components.calendar : nil
        newDate.timeZone = units.contains(.TimeZone) ? components.timeZone : nil
        return newDate
    }

    func definedUnits() -> NSCalendarUnit {
        var units = componentFlags
        for unit in componentFlagSet {
            if self.components.valueForComponent(unit) == NSDateComponentUndefined {
                units.remove(unit)
            }
        }
        if components.calendar == nil { units.remove(.Calendar) }
        if components.timeZone == nil { units.remove(.TimeZone) }
        return units
    }

    private func unitValue(unit: NSCalendarUnit) -> Int? {

        // return the component value if it is defined
        let value = components.valueForComponent(unit)
        if value != NSDateComponentUndefined {
            return value
        }

        // component is undefined, try to determine it from the date
        guard !strictEvaluation else {
            return nil
        }

        let theCalendar = calendar ?? NSCalendar.currentCalendar()
        theCalendar.timeZone = timeZone ?? NSTimeZone.defaultTimeZone()
        let dateComponents = theCalendar.components(unit, fromDate: date!)
        return dateComponents.valueForComponent(unit)
    }

    var year: Int? {
        get { return unitValue(.Year) }
        set { components.year = newValue ?? NSDateComponentUndefined }
    }

    var month: Int? {
        get { return unitValue(.Month) }
        set { components.month = newValue ?? NSDateComponentUndefined }
    }

    var day: Int? {
        get { return unitValue(.Day) }
        set { components.day = newValue ?? NSDateComponentUndefined }
    }

    var hour: Int? {
        get { return unitValue(.Hour) }
        set { components.hour = newValue ?? NSDateComponentUndefined }
    }

    var minute: Int? {
        get { return unitValue(.Minute) }
        set { components.minute = newValue ?? NSDateComponentUndefined }
    }

    var second: Int? {
        get { return unitValue(.Second) }
        set { components.second = newValue ?? NSDateComponentUndefined }
    }

    var nanosecond: Int? {
        get { return unitValue(.Nanosecond) }
        set { components.nanosecond = newValue ?? NSDateComponentUndefined }
    }

    var yearForWeekOfYear: Int? {
        get { return unitValue(.YearForWeekOfYear) }
        set { components.yearForWeekOfYear = newValue ?? NSDateComponentUndefined }
    }

    var weekOfYear: Int? {
        get { return unitValue(.WeekOfYear) }
        set { components.weekOfYear = newValue ?? NSDateComponentUndefined }
    }

    var weekday: Int? {
        get { return unitValue(.Weekday) }
        set { components.weekday = newValue ?? NSDateComponentUndefined }
    }
    
    var timeZone: NSTimeZone? {
        get { return components.timeZone ?? (strictEvaluation ? nil : NSTimeZone.defaultTimeZone()) }
        set { components.timeZone = newValue }
    }

    var calendar: NSCalendar? {
        get { return components.calendar ?? (strictEvaluation ? nil : NSCalendar.currentCalendar()) }
        set { components.calendar = newValue }
    }
    
    var date: NSDate? {
        get {
            if strictEvaluation {
                return components.date
            }

            // Not strict, so return reference date components if they are undefined
            let result = NSDateComponents()
            result.year = 2001
            result.month = 1
            result.day = 1
            result.hour = 0
            result.minute = 0
            result.second = 0
            result.nanosecond = 0
            result.calendar = calendar
            result.timeZone = timeZone

            for unit in componentFlagSet {
                let value = self.components.valueForComponent(unit)
                if value != NSDateComponentUndefined {
                    result.setValue(value, forComponent: unit)
                }
            }
            return result.date
        }
    }

    var validDate: Bool {
        let theComponents = components
        theComponents.calendar = calendar
        theComponents.timeZone = timeZone
        return theComponents.validDate
    }

    func isValidDateInCalendar(calendar: NSCalendar) -> Bool {
        let theComponents = components
        theComponents.calendar = calendar
        theComponents.timeZone = timeZone
        return theComponents.isValidDateInCalendar(calendar)
    }

}

extension JHDate : CustomStringConvertible {

    public var description: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee dd-MMM-yy GG HH:mm:ss.SSS zzz"
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        let dateString = date == nil ? "nil" : dateFormatter.stringFromDate(date!)
        return "\(components.description)\nStrict evaluation: \(strictEvaluation)\nDate: \(dateString)"
    }

}


public extension JHDate {
    func startOf(unit: NSCalendarUnit) -> JHDate? {
        guard calendar != nil else {
            return nil
        }

        let nextSmallerUnit = --unit
        guard nextSmallerUnit != nil else {
            return self
        }

        let range = calendar!.rangeOfUnit(nextSmallerUnit!, inUnit: unit, forDate: self.date!)
        components.setValue(range.location, forComponent: nextSmallerUnit!)

        // debug code
        //print(components)
        //print(date)

        return startOf(nextSmallerUnit!)
    }

    func endOf(unit: NSCalendarUnit) -> JHDate? {
        guard calendar != nil else {
            return nil
        }

        let nextSmallerUnit = --unit
        guard nextSmallerUnit != nil else {
            return self
        }

        let range = calendar!.rangeOfUnit(nextSmallerUnit!, inUnit: unit, forDate: self.date!)
        components.setValue(range.location + range.length - 1, forComponent: nextSmallerUnit!)

        // debug code 
        //print(components)
        //print(date)
        
        return endOf(nextSmallerUnit!)
    }

}

// MARK: - Comparators
public extension JHDate {

    func hasTheSame(unitFlags: NSCalendarUnit, asDate: JHDate) -> Bool {
        for flag in componentFlagSet {
            if self.components.valueForComponent(flag) != asDate.components.valueForComponent(flag) {
                return false
            }
        }
        return true
    }

    public func isToday() -> Bool {
        return self.hasTheSame(.Day, asDate: JHDate(date: NSDate()))
    }

}


public func ==(lhs: JHDate, rhs: JHDate) -> Bool {
    for flag in componentFlagSet {
        if lhs.components.valueForComponent(flag) != rhs.components.valueForComponent(flag) {
            return false
        }
    }
    if lhs.calendar != rhs.calendar { return false }
    if lhs.timeZone != rhs.timeZone { return false }
    if lhs.strictEvaluation != rhs.strictEvaluation { return false }
    return true
}

public func <(lhs: JHDate, rhs: JHDate) -> Bool {
    guard lhs.validDate else {
        return false
    }
    guard rhs.validDate else {
        return false
    }
    let lDate = lhs.date!
    let rDate = rhs.date!
    return lDate.timeIntervalSinceReferenceDate < rDate.timeIntervalSinceReferenceDate
}



// MARK: - Operators
extension JHDate {
    func difference(toDate: JHDate, unitFlags: NSCalendarUnit) -> NSDateComponents? {
        guard calendar != nil else {
            return nil
        }
        guard validDate else {
            return nil
        }
        guard toDate.validDate else {
            return nil
        }
        return calendar!.components(unitFlags, fromDate: self.date!, toDate: toDate.date!, options: NSCalendarOptions(rawValue: 0))
    }
}

public prefix func --(unit: NSCalendarUnit) -> NSCalendarUnit? {
    switch unit {
    case NSCalendarUnit.Era: return .Year
    case NSCalendarUnit.Year: return .Month
    case NSCalendarUnit.Month: return .Day
    case NSCalendarUnit.Day: return .Hour
    case NSCalendarUnit.Hour: return .Minute
    case NSCalendarUnit.Minute: return .Second
    case NSCalendarUnit.Second: return .Nanosecond
    case NSCalendarUnit.Nanosecond: return nil
    case NSCalendarUnit.YearForWeekOfYear: return .WeekOfYear
    case NSCalendarUnit.WeekOfYear: return .Weekday
    case NSCalendarUnit.Weekday: return .Hour
    default: return nil
    }
}


public func - (lhs: JHDate, rhs: NSDateComponents) -> JHDate? {
    return lhs + (-rhs)
}

public func + (lhs: JHDate, rhs: NSDateComponents) -> JHDate? {
    guard lhs.validDate else {
        return nil
    }
    let calendar = lhs.calendar!
    let resultDate = calendar.dateByAddingComponents(rhs, toDate: lhs.date!, options: NSCalendarOptions(rawValue: 0))
    guard resultDate != nil else {
        return nil
    }
    return JHDate(date: resultDate!).filterUnits(lhs.definedUnits())
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


public extension Int {
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


