//
//  JHDateSpec.swift
//  JHDate
//
//  Created by Jeroen Houtzager on 12/10/15.
//  Copyright © 2015 Jeroen Houtzager. All rights reserved.
//
// https://github.com/Quick/Quick


import Quick
import Nimble
import JHDate

class JHDateSpec: QuickSpec {

    override func spec() {

        describe("JHDate") {

            context("NSDate, calendar & time zone initialisation") {

                it("should have the default time zone in the current calendar") {
                    let calendar = NSCalendar.currentCalendar()
                    let expectedTimeZone = NSTimeZone.defaultTimeZone()
                    expect(calendar.timeZone) == expectedTimeZone
                }

                it("should have the the current calendar as default") {
                    let date = JHDate()
                    let expectedCalendar = NSCalendar.currentCalendar()
                    expect(date.calendar) == expectedCalendar
                }

                it("should have the specified calendar") {
                    let calendar = NSCalendar(identifier: NSCalendarIdentifierPersian)
                    let date = JHDate(calendar: calendar)
                    expect(date.calendar) == calendar
                }

                it("should have the specified time zone") {
                    let timeZone = NSTimeZone(forSecondsFromGMT: 12345)
                    let date = JHDate(timeZone: timeZone)
                    expect(date.timeZone) == timeZone
                }

                it("should return the current date") {
                    let jhDate = JHDate()
                    let nsDate = NSDate()

                    let timeZone = NSTimeZone.defaultTimeZone()
                    let expectedInterval = NSTimeInterval(Double(nsDate.timeIntervalSinceReferenceDate) + Double(timeZone.secondsFromGMT))
                    expect(jhDate.timeIntervalSinceReferenceDate) ≈ (expectedInterval, 1)
                }
                
                it("should return the sepcified date") {
                    let calendar = NSCalendar(identifier: NSCalendarIdentifierJapanese)!
                    let components = NSDateComponents()
                    components.year = 2345
                    components.month = 12
                    components.day = 5
                    let nsDate = calendar.dateFromComponents(components)!

                    let jhDate = JHDate(date: nsDate)

                    let expectedInterval = NSTimeInterval(Double(nsDate.timeIntervalSinceReferenceDate) + Double(calendar.timeZone.secondsFromGMTForDate(nsDate)))
                    expect(jhDate.timeIntervalSinceReferenceDate) == expectedInterval
                }
            }

            context("component initialisation") {

                it("should return a midnight date with nil YMD initialisation with UTC time zone") {
                    let UTCTimeZone = NSTimeZone(forSecondsFromGMT: 0)
                    let date = JHDate(year: 1912, month: 6, day: 23, timeZone: UTCTimeZone)!
                    let calendar = date.calendar
                    calendar.timeZone = UTCTimeZone

                    expect(date.year) == 1912
                    expect(date.month) == 6
                    expect(date.day) == 23
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                    expect(date.calendar) == calendar
                    expect(date.timeZone) == UTCTimeZone
                }


                it("should return a midnight date with nil YMD initialisation") {
                    let date = JHDate(year: 1912, month: 6, day: 23)!

                    expect(date.year) == 1912
                    expect(date.month) == 6
                    expect(date.day) == 23
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                    expect(date.calendar) == NSCalendar.currentCalendar()
                    expect(date.timeZone) == NSTimeZone.defaultTimeZone()
                }


                it("should return a midnight date with nil YWD initialisation") {
                    let date = JHDate(yearForWeekOfYear: 1492, weekOfYear: 15, weekday: 4)!

                    expect(date.year) == 1492
                    expect(date.month) == 4
                    expect(date.day) == 6
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                    expect(date.calendar) == NSCalendar.currentCalendar()
                    expect(date.timeZone) == NSTimeZone.defaultTimeZone()
                }


                it("should return a 123 date for YMD initialisation") {
                    let date = JHDate(year: 1999, month: 12, day: 31)!

                    expect(date.year) == 1999
                    expect(date.month) == 12
                    expect(date.day) == 31
                    expect(date.calendar) == NSCalendar.currentCalendar()
                    expect(date.timeZone) == NSTimeZone.defaultTimeZone()
                }

                it("should return a 123 date for YWD initialisation") {
                    let date = JHDate(yearForWeekOfYear: 2016, weekOfYear: 1, weekday: 1)!

                    expect(date.yearForWeekOfYear) == 2016
                    expect(date.weekOfYear) == 1
                    expect(date.weekday) == 1
                }

                it("should return a date of 0001-01-01 00:00:00.000 UTC for component initialisation") {
                    let components = NSDateComponents()
                    let date = JHDate(components: components)!

                    expect(date.year) == 2001
                    expect(date.month) == 1
                    expect(date.day) == 1
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                }

                it("should return a proper date") {
                    let timeZone = NSTimeZone(abbreviation: "GST")!
                    let date = JHDate(year: 1999, month: 12, day: 31, timeZone: timeZone)!
                    let components = NSDateComponents()
                    components.year = 1999
                    components.month = 12
                    components.day = 31
                    components.timeZone = timeZone
                    let expectedDate = date.calendar.dateFromComponents(components)

                    expect(date) == JHDate(date: expectedDate, timeZone: timeZone)
                }

            }

            context("class func") {

                it("should return a proper current date for today") {
                    let today = JHDate.today()

                    expect(today.calendar.isDateInToday(today.date))
                }

                it("should return a proper tomorrow") {
                    let tomorrow = JHDate.tomorrow()

                    expect(tomorrow.calendar.isDateInTomorrow(tomorrow.date))
                }

                it("should return a proper yesterday") {
                    let yesterday = JHDate.yesterday()

                    expect(yesterday.calendar.isDateInYesterday(yesterday.date))
                }

            }

            context("properties") {
                it("should return proper normal YMD properties") {
                    let date = JHDate(year: 1999, month: 12, day: 31)!
                    expect(date.year) == 1999
                    expect(date.month) == 12
                    expect(date.day) == 31
                }
                it("should return proper normal HMSN properties") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 500000000)!
                    expect(date.year) == 1999
                    expect(date.month) == 12
                    expect(date.day) == 31
                    expect(date.hour) == 23
                    expect(date.minute) == 59
                    expect(date.second) == 59
                    expect(date.nanosecond) > 400000000
                    expect(date.nanosecond) < 600000000
                }
                it("should return proper leap month") {
                    for year in 1500...2500 {
                        let date = JHDate(year: year, month: 2, day: 1)!

                        if year % 400 == 0 {
                            expect(date.leapMonth).to(beTrue(), description: "year \(year) is divisable by 400 and is leap")
                        } else if year % 100 == 0 {
                            expect(date.leapMonth).to(beFalse(), description: "year \(year) is divisable by 100 and is NOT leap")
                        } else if year % 4 == 0 {
                            expect(date.leapMonth).to(beTrue(), description: "year \(year) is divisable by 4 and is leap")
                        } else {
                            expect(date.leapMonth).to(beFalse(), description: "year \(year) is NOT divisable by 4 and is NOT leap")
                        }
                    }
                }
            }

            context("descriptions") {
                it("Should output a proper description") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 500000000, calendar: NSCalendar(identifier: NSCalendarIdentifierGregorian), timeZone: NSTimeZone(abbreviation: "CET"))!
                    let descriptions = date.description.componentsSeparatedByString(" ")

                    expect(descriptions[0]) == "Date"
                    expect(descriptions[1]) == "Fri"
                    expect(descriptions[2]) == "31-Dec-1999"
                    expect(descriptions[3]) == "AD"
                    expect(descriptions[4]) == "23:59:59.500"
                    expect(descriptions[5]) == "GMT+1\nCalendar:"
                    expect(descriptions[8]) == "zone:"
                    expect(descriptions[9]) == "Europe/Paris"
                    expect(descriptions[10]) == "(GMT+1)"
                    expect(descriptions[11]) == "offset"
                    expect(descriptions[12]) == "3600"
                }
            }

            context("comparisons") {

                it("should return true for greater than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)!
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date1 > date2) == true
                }

                it("should return false for greater than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date2 > date2) == false
                }

                it("should return false for greater than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date2 > date1) == false
                }

                it("should return true for less than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 29)!
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date1 < date2) == true
                }

                it("should return false for less than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date2 < date2) == false
                }

                it("should return false for less than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 29)!
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date2 < date1) == false
                }

                it("should return true for greater-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)!
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date1 >= date2) == true
                }

                it("should return false for greater-equal than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date2 >= date2) == true
                }

                it("should return false for greater-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)!
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date2 >= date1) == false
                }

                it("should return true for less-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 29)!
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date1 <= date2) == true
                }

                it("should return false for less-equal than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)!

                    expect(date2) <= date2
                }

                it("should return false for less-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 29)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

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
                    let date = JHDate(year: 1999, month: 12, day: 31)!
                    print(date)
                    let testDate = date + 1.days
                    print(testDate)
                    let expectedDate = JHDate(year: 2000, month: 1, day: 1)

                    expect(testDate) == expectedDate
                }

                it("should add properly") {
                    let date = JHDate(year: 1999, month: 12, day: 31)!
                    let testDate = (date + 1.weeks)!

                    expect(testDate.year) == 2000
                    expect(testDate.month) == 1
                    expect(testDate.day) == 7
                }

                it("should subtract properly") {
                    let date = JHDate(year: 2000, month: 1, day: 1)!
                    let testDate = date - 1.days
                    let expectedDate = JHDate(year: 1999, month: 12, day: 31)

                    expect(testDate) == expectedDate
                }

                it("should differ properly") {
                    let date1 = JHDate(year: 2001, month: 2, day: 1)!
                    let date2 = JHDate(year: 2003, month: 1, day: 10)!
                    let components = date1.difference(date2.date, unitFlags: [.Month, .Year])

                    let expectedComponents = NSDateComponents()
                    expectedComponents.month = 11
                    expectedComponents.year = 1

                    expect(components) == expectedComponents
                }

            }

            context("start of unit") {

                it("should return start of day for time during day") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.startOf(.Day)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 12
                    expect(testDate.day) == 31
                    expect(testDate.hour) == 0
                    expect(testDate.minute) == 0
                    expect(testDate.second) == 0
                    expect(testDate.nanosecond) == 0
                }

                it("should return start of day for midnight") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 0, minute: 0, second: 0, nanosecond: 0)!
                    let testDate = date.startOf(.Day)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 12
                    expect(testDate.day) == 31
                    expect(testDate.hour) == 0
                    expect(testDate.minute) == 0
                    expect(testDate.second) == 0
                    expect(testDate.nanosecond) == 0
                }

                it("should return start of month") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.startOf(.Month)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 12
                    expect(testDate.day) == 1
                    expect(testDate.hour) == 0
                    expect(testDate.minute) == 0
                    expect(testDate.second) == 0
                    expect(testDate.nanosecond) == 0
                }

                it("should return start of year") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.startOf(.Year)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 1
                    expect(testDate.day) == 1
                    expect(testDate.hour) == 0
                    expect(testDate.minute) == 0
                    expect(testDate.second) == 0
                    expect(testDate.nanosecond) == 0
                }

            }

            context("end of unit") {

                it("should return end of day") {
                    let date = JHDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.endOf(.Day)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 1
                    expect(testDate.day) == 1
                    expect(testDate.hour) == 23
                    expect(testDate.minute) == 59
                    expect(testDate.second) == 59
                }
                
                it("should return end of month") {
                    let date = JHDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.endOf(.Month)!
                    
                    expect(testDate.year) == 1999
                    expect(testDate.month) == 1
                    expect(testDate.day) == 31
                    expect(testDate.hour) == 23
                    expect(testDate.minute) == 59
                    expect(testDate.second) == 59
                }
                
                it("should return end of year") {
                    let date = JHDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)!
                    let testDate = date.endOf(.Year)!
                    
                    expect(testDate.year) == 1999
                    expect(testDate.month) == 12
                    expect(testDate.day) == 31
                    expect(testDate.hour) == 23
                    expect(testDate.minute) == 59
                    expect(testDate.second) == 59
                }
                
            }
        }
        
    }
    
}
