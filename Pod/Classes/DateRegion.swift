//
//  DateRegion.swift
//  Pods
//
//  Created by Jeroen Houtzager on 09/11/15.
//
//

public struct DateRegion: Equatable {

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
    
    /// Initialise with a calendar and/or a time zone
    ///
    /// - Parameters:
    ///     - calendar:   the calendar to work with to assign, default = the current calendar
    ///     - timeZone:   the time zone to work with, default is the default time zone
    ///     - locale:     the locale to work with, default is the current locale
    ///
    public init(
        calendar aCalendar: NSCalendar? = nil,
        timeZone aTimeZone: NSTimeZone? = nil,
        locale aLocale: NSLocale? = nil) {
            calendar = aCalendar ?? NSCalendar.currentCalendar()
            timeZone = aTimeZone ?? NSTimeZone.defaultTimeZone()
            locale = aLocale ?? aCalendar?.locale ?? NSLocale.currentLocale()

            // Assign calendar fields
            calendar.timeZone = timeZone
            calendar.locale = locale
    }
    
    public init(
        calendarID: String,
        timeZoneID: String = "",
        localeID: String = "") {
            calendar = NSCalendar(calendarIdentifier: calendarID) ?? NSCalendar.currentCalendar()
            timeZone = NSTimeZone(abbreviation: timeZoneID) ?? NSTimeZone.defaultTimeZone()
            locale = NSLocale(localeIdentifier: localeID) ?? NSLocale.currentLocale()

            // Assign calendar fields
            calendar.timeZone = timeZone
            calendar.locale = locale
    }
    
    /// Today's date
    ///
    /// - Returns: the date of today at midnight (00:00) in the current calendar and default time zone.
    ///
    public func today() -> JHDate {
        let components = calendar.components([.Era, .Year, .Month, .Day, .Calendar, .TimeZone], fromDate: NSDate())
        let date = calendar.dateFromComponents(components)!
        return JHDate(date: date, region: self)
    }

    /// Yesterday's date
    ///
    /// - Returns: the date of yesterday at midnight (00:00) in the current calendar and default time zone.
    ///
    public func yesterday() -> JHDate {
        return (today() - 1.days)!
    }

    /// Tomorrow's date
    ///
    /// - Returns: the date of tomorrow at midnight (00:00) in the current calendar and default time zone.
    ///
    public func tomorrow() -> JHDate {
        return (today() + 1.days)!
    }

}

public func ==(left: DateRegion, right: DateRegion) -> Bool {
    if left.calendar.calendarIdentifier != right.calendar.calendarIdentifier {
        return false
    }

    if left.timeZone.secondsFromGMT == right.timeZone.secondsFromGMT {
        return false
    }

    if left.locale.localeIdentifier == right.locale.localeIdentifier  {
        return false
    }

    return true
}