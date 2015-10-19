//
//  NSDateSpec.swift
//  JHCalendar
//
//  Created by Jeroen Houtzager on 12/10/15.
//  Copyright © 2015 Jeroen Houtzager. All rights reserved.
//

import Quick
import Nimble
@testable import JHDate

class JHDateSpec: QuickSpec {

    override func spec() {

        describe("NSDate") {

            context("Calendar & time zone") {

                it("should have the default time zone in the current calendar") {
                    let calendar = NSCalendar.currentCalendar()
                    let expectedTimeZone = NSTimeZone.defaultTimeZone()
                    expect(calendar.timeZone) == expectedTimeZone
                }

                it("should have the the current calendar as default") {
                    let date = NSDate()
                    let expectedCalendar = NSCalendar.currentCalendar()
                    expect(date.calendar()) == expectedCalendar
                }

            }

            context("Default components") {
                it("should return a preper default date in the current time zone") {
                    let components = NSDate.defaultComponents()
                    expect(components.year) == 2001
                    expect(components.month) == 1
                    expect(components.day) == 1
                    expect(components.hour) == 0
                    expect(components.minute) == 0
                    expect(components.second) == 0
                    expect(components.nanosecond) == 0
                    expect(components.timeZone) == NSTimeZone.defaultTimeZone()
                    expect(components.calendar) == NSCalendar.currentCalendar()
                }


                it("should return a preper default date in the UTC time zone") {
                    let timeZone = NSTimeZone(forSecondsFromGMT: 0)
                    let calendar = NSCalendar.currentCalendar()
                    calendar.timeZone = timeZone
                    let components = NSDate.defaultComponents(withCalendar: calendar)

                    expect(components.year) == 2001
                    expect(components.month) == 1
                    expect(components.day) == 1
                    expect(components.hour) == 0
                    expect(components.minute) == 0
                    expect(components.second) == 0
                    expect(components.nanosecond) == 0
                    expect(components.timeZone) == timeZone
                    expect(components.calendar) == NSCalendar.currentCalendar()
                }

                it("should return a preper default date in some other time zone") {
                    let timeZone = NSTimeZone(forSecondsFromGMT: 4545)
                    let calendar = NSCalendar.currentCalendar()
                    calendar.timeZone = timeZone
                    let components = NSDate.defaultComponents(withCalendar: calendar)

                    expect(components.year) == 2001
                    expect(components.month) == 1
                    expect(components.day) == 1
                    expect(components.hour) == 0
                    expect(components.minute) == 0
                    expect(components.second) == 0
                    expect(components.nanosecond) == 0
                    expect(components.timeZone) == timeZone
                    expect(components.calendar) == NSCalendar.currentCalendar()
                }

            }

            context("Initialisation") {

                it("should return a midnight date with nil YMD initialisation with UTC time zone") {
                    let UTCTimeZone = NSTimeZone(forSecondsFromGMT: 0)
                    let date = NSDate(year: 1912, month: 6, day: 23, timeZone: UTCTimeZone)!
                    let calendar = date.calendar()
                    calendar.timeZone = UTCTimeZone

                    expect(date.year(withCalendar: calendar)) == 1912
                    expect(date.month(withCalendar: calendar)) == 6
                    expect(date.day(withCalendar: calendar)) == 23
                    expect(date.hour(withCalendar: calendar)) == 0
                    expect(date.minute(withCalendar: calendar)) == 0
                    expect(date.second(withCalendar: calendar)) == 0
                    expect(date.nanosecond(withCalendar: calendar)) == 0
                }

                
                it("should return a midnight date with nil YMD initialisation") {
                    let date = NSDate(year: 1912, month: 6, day: 23)!

                    expect(date.year()) == 1912
                    expect(date.month()) == 6
                    expect(date.day()) == 23
                    expect(date.hour()) == 0
                    expect(date.minute()) == 0
                    expect(date.second()) == 0
                    expect(date.nanosecond()) == 0
                }

                
                it("should return a midnight date with nil YWD initialisation") {
                    let date = NSDate(yearForWeekOfYear: 1492, weekOfYear: 15, weekday: 4)!

                    expect(date.year()) == 1492
                    expect(date.month()) == 4
                    expect(date.day()) == 6
                    expect(date.hour()) == 0
                    expect(date.minute()) == 0
                    expect(date.second()) == 0
                    expect(date.nanosecond()) == 0
                }
                
                
                it("should return a 123 date for YMD initialisation") {
                    let date = NSDate(year: 1999, month: 12, day: 31)!

                    expect(date.year()) == 1999
                    expect(date.month()) == 12
                    expect(date.day()) == 31
                }
                
                it("should return a 123 date for YWD initialisation") {
                    let date = NSDate(yearForWeekOfYear: 2016, weekOfYear: 1, weekday: 1)!

                    expect(date.yearForWeekOfYear()) == 2016
                    expect(date.weekOfYear()) == 1
                    expect(date.weekday()) == 1
                }

                it("should return a date of 0001-01-01 00:00:00.000 UTC for component initialisation") {
                    let components = NSDateComponents()
                    let date = NSDate(components: components)!

                    expect(date.year()) == 2001
                    expect(date.month()) == 1
                    expect(date.day()) == 1
                    expect(date.hour()) == 0
                    expect(date.minute()) == 0
                    expect(date.second()) == 0
                    expect(date.nanosecond()) == 0
                }

                it("should return a proper date") {
                    let timeZone = NSTimeZone(abbreviation: "GST")!
                    let date = NSDate(year: 1999, month: 12, day: 31, timeZone: timeZone)!
                    let components = NSDateComponents()
                    components.year = 1999
                    components.month = 12
                    components.day = 31
                    components.timeZone = timeZone
                    let expectedDate = date.calendar().dateFromComponents(components)

                    expect(date) == expectedDate
                }

            }

            context("class func") {

                it("should return a proper current date for today") {
                    let today = NSDate.today()

                    expect(today.calendar().isDateInToday(today))
                }
                
                it("should return a proper tomorrow") {
                    let tomorrow = NSDate.tomorrow()

                    expect(tomorrow.calendar().isDateInTomorrow(tomorrow))
                }
                
                it("should return a proper yesterday") {
                    let yesterday = NSDate.yesterday()

                    expect(yesterday.calendar().isDateInYesterday(yesterday))
                }
                
                it("should return a proper current date for now") {
                    let now = NSDate()
                    let expectedDate = NSDate()

                    expect(now.timeIntervalSinceReferenceDate) ≈ (expectedDate.timeIntervalSinceReferenceDate, 1)
                }
                
            }

            context("comparisons") {

                it("should return true for greater than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 31)!
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date1 > date2) == true
                }

                it("should return false for greater than comparing") {
                    let date2 = NSDate(year: 1999, month: 12, day: 30)

                    expect(date2 > date2) == false
                }

                it("should return false for greater than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 31)
                    let date2 = NSDate(year: 1999, month: 12, day: 30)

                    expect(date2 > date1) == false
                }

                it("should return true for less than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 29)!
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date1 < date2) == true
                }

                it("should return false for less than comparing") {
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date2 < date2) == false
                }

                it("should return false for less than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 29)!
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!
                    
                    expect(date2 < date1) == false
                }

                it("should return true for greater-equal than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 31)!
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date1 >= date2) == true
                }

                it("should return false for greater-equal than comparing") {
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date2 >= date2) == true
                }

                it("should return false for greater-equal than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 31)!
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date2 >= date1) == false
                }

                it("should return true for less-equal than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 29)!
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date1 <= date2) == true
                }

                it("should return false for less-equal than comparing") {
                    let date2 = NSDate(year: 1999, month: 12, day: 30)!

                    expect(date2) <= date2
                }

                it("should return false for less-equal than comparing") {
                    let date1 = NSDate(year: 1999, month: 12, day: 29)
                    let date2 = NSDate(year: 1999, month: 12, day: 30)
                    
                    expect(date2 <= date1) == false
                }
            }

            context("Int extensions") {

                it("should return proper integer extension values") {
                    let expectedComponents = NSDateComponents()
                    expectedComponents.day = 1
                    expect(1.days) == expectedComponents
                }

            }

            context("operations") {

                it("should add properly") {
                    let date = NSDate(year: 1999, month: 12, day: 31)!
                    print(date)
                    let testDate = date + 1.days
                    print(testDate)
                    let expectedDate = NSDate(year: 2000, month: 1, day: 1)

                    expect(testDate) == expectedDate
                }
                
                it("should add properly") {
                    let date = NSDate(year: 1999, month: 12, day: 31)!
                    let testDate = (date + 1.weeks)!

                    expect(testDate.year()) == 2000
                    expect(testDate.month()) == 1
                    expect(testDate.day()) == 7
                }
                
                it("should subtract properly") {
                    let date = NSDate(year: 2000, month: 1, day: 1)!
                    let testDate = date - 1.days
                    let expectedDate = NSDate(year: 1999, month: 12, day: 31)

                    expect(testDate) == expectedDate
                }
                
                it("should differ properly") {
                    let date1 = NSDate(year: 2001, month: 2, day: 1)!
                    let date2 = NSDate(year: 2003, month: 1, day: 10)!
                    let components = date1.difference(date2, unitFlags: [.Month, .Year])

                    let expectedComponents = NSDateComponents()
                    expectedComponents.month = 11
                    expectedComponents.year = 1

                    expect(components) == expectedComponents
                }
                
            }

            context("start of unit") {

                it("should return start of day for time during day") {
                    let date = NSDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.startOf(.Day)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 12
                    expect(testDate.day()) == 31
                    expect(testDate.hour()) == 0
                    expect(testDate.minute()) == 0
                    expect(testDate.second()) == 0
                    expect(testDate.nanosecond()) == 0
                }
                
                it("should return start of day for midnight") {
                    let date = NSDate(year: 1999, month: 12, day: 31, hour: 0, minute: 0, second: 0, nanosecond: 0)!
                    let testDate = date.startOf(.Day)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 12
                    expect(testDate.day()) == 31
                    expect(testDate.hour()) == 0
                    expect(testDate.minute()) == 0
                    expect(testDate.second()) == 0
                    expect(testDate.nanosecond()) == 0
                }
                
                it("should return start of month") {
                    let date = NSDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.startOf(.Month)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 12
                    expect(testDate.day()) == 1
                    expect(testDate.hour()) == 0
                    expect(testDate.minute()) == 0
                    expect(testDate.second()) == 0
                    expect(testDate.nanosecond()) == 0
                }
                
                it("should return start of year") {
                    let date = NSDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.startOf(.Year)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 1
                    expect(testDate.day()) == 1
                    expect(testDate.hour()) == 0
                    expect(testDate.minute()) == 0
                    expect(testDate.second()) == 0
                    expect(testDate.nanosecond()) == 0
                }
                
            }

            context("end of unit") {

                it("should return end of day") {
                    let date = NSDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.endOf(.Day)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 1
                    expect(testDate.day()) == 1
                    expect(testDate.hour()) == 23
                    expect(testDate.minute()) == 59
                    expect(testDate.second()) == 59
                }

                it("should return end of month") {
                    let date = NSDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.endOf(.Month)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 1
                    expect(testDate.day()) == 31
                    expect(testDate.hour()) == 23
                    expect(testDate.minute()) == 59
                    expect(testDate.second()) == 59
                }

                it("should return end of year") {
                    let date = NSDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.endOf(.Year)!

                    expect(testDate.year()) == 1999
                    expect(testDate.month()) == 12
                    expect(testDate.day()) == 31
                    expect(testDate.hour()) == 23
                    expect(testDate.minute()) == 59
                    expect(testDate.second()) == 59
                }
                
            }
        }
        
    }
    
}
