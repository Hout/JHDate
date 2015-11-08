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

        var gregorianCalendar: NSCalendar!
        beforeEach {
            gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        }

        describe("JHDate") {

            context("NSDate, calendar & time zone initialisation") {

                it("should have the default time zone in the current calendar") {
                    let expectedTimeZone = NSTimeZone.defaultTimeZone()
                    expect(gregorianCalendar.timeZone) == expectedTimeZone
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

                it("should have the specified locale") {
                    let locale = NSLocale(localeIdentifier: "fr_FR")
                    let date = JHDate(locale: locale)
                    expect(date.locale) == locale
                }

                it("should have the specified time zone") {
                    let timeZone = NSTimeZone(forSecondsFromGMT: 12345)
                    let date = JHDate(timeZone: timeZone)
                    expect(date.timeZone) == timeZone
                }

                it("should return the current date") {
                    let jhDate = JHDate(calendar: gregorianCalendar)
                    let nsDate = NSDate()

                    let timeZone = NSTimeZone.defaultTimeZone()
                    let expectedInterval = NSTimeInterval(Double(nsDate.timeIntervalSinceReferenceDate) + Double(timeZone.secondsFromGMT))
                    expect(jhDate.timeIntervalSinceReferenceDate) ≈ (expectedInterval, 1)
                }

                it("should return the specified date") {
                    let calendar = NSCalendar(identifier: NSCalendarIdentifierJapanese)!
                    let components = NSDateComponents()
                    components.year = 2345
                    components.month = 12
                    components.day = 5
                    let nsDate = calendar.dateFromComponents(components)!

                    let jhDate = JHDate(date: nsDate, calendar: gregorianCalendar)

                    let expectedInterval = NSTimeInterval(Double(nsDate.timeIntervalSinceReferenceDate) + Double(calendar.timeZone.secondsFromGMTForDate(nsDate)))
                    expect(jhDate.timeIntervalSinceReferenceDate) == expectedInterval
                }
            }

            context("NSDate ports") {

                it("should return a zero time interval for 1-Jan-2001 00:00:00.000 UTC") {
                    let refDate = NSDate(timeIntervalSinceReferenceDate: 0)
                    let date = JHDate(date: refDate, calendar: gregorianCalendar, timeZone: NSTimeZone(forSecondsFromGMT: 0))

                    expect(date.timeIntervalSinceReferenceDate) == 0
                }
                
                it("should return a 3600 time interval for 1-Jan-2001 00:00:00.000 CET") {
                    let refDate = NSDate(timeIntervalSinceReferenceDate: 0)
                    let date = JHDate(date: refDate, calendar: gregorianCalendar, timeZone: NSTimeZone(abbreviation: "CET"))

                    expect(date.timeIntervalSinceReferenceDate) == 3600
                }

                it("should report the maximum date") {
                    let testDate = JHDate(year: 5, month: 2, day: 3, calendar: gregorianCalendar)!
                    let maxDate = JHDate.latestDate(
                        JHDate(year: 1, month: 2, day: 3, calendar: gregorianCalendar)!,
                        JHDate(year: 2, month: 2, day: 3, calendar: gregorianCalendar)!,
                        JHDate(year: 3, month: 2, day: 3, calendar: gregorianCalendar)!,
                        testDate,
                        JHDate(year: 4, month: 2, day: 3, calendar: gregorianCalendar)!)
                    expect(maxDate) == testDate
                }

                it("should report the minimum date") {
                    let testDate = JHDate(year: 100, month: 2, day: 3)!
                    let minDate = JHDate.earliestDate(
                        JHDate(year: 101, month: 2, day: 3)!,
                        JHDate(year: 102, month: 2, day: 3)!,
                        JHDate(year: 103, month: 2, day: 3)!,
                        testDate,
                        JHDate(year: 104, month: 2, day: 3)!)
                    expect(minDate) == testDate
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
                    let localeNL = NSLocale(localeIdentifier: "nl_NL")
                    let date = JHDate(yearForWeekOfYear: 1492, weekOfYear: 15, weekday: 4, calendar: gregorianCalendar, locale: localeNL)!

                    expect(date.year) == 1492
                    expect(date.month) == 4
                    expect(date.day) == 6
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                    expect(date.calendar) == gregorianCalendar
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
                    let nsDate = NSCalendar.currentCalendar().dateFromComponents(components)
                    let date = JHDate(components: components)!
                    let expectedDate = JHDate(date: nsDate)

                    expect(date) == expectedDate
                }

                it("should return a proper date") {
                    let timeZone = NSTimeZone(abbreviation: "GST")!
                    let date = JHDate(year: 1999, month: 12, day: 31, timeZone: timeZone)!
                    let components = date.components
                    expect(components.year) == 1999
                    expect(components.month) == 12
                    expect(components.day) == 31
                    expect(components.timeZone) == timeZone
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

                it("should return proper leap month for Gregorian calendars") {
                    for year in 1500...2500 {
                        let date = JHDate(year: year, month: 2, day: 1, calendar: gregorianCalendar)!

                        if year < 1582 {
                            expect(date.leapMonth).to(beFalse(), description: "years < 1582 have no leap year")
                        } else if year % 400 == 0 {
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
                
                it("should not return leap month for non-February months in Gregorian calendars") {
                    for month in 1...12 {
                        // Skip February
                        if month == 2 { continue }

                        let date = JHDate(year: 2000, month: month, day: 1, calendar: gregorianCalendar)!

                        expect(date.leapMonth).to(beFalse(), description: "months other than February can never be leap months")
                    }
                }
                
                it("should return proper leap year for Gregorian calendars") {
                    for year in 1500...2500 {
                        let date = JHDate(year: year, month: 8, day: 1, calendar: gregorianCalendar)!

                        if year < 1582 {
                            expect(date.leapYear).to(beFalse(), description: "years < 1582 have no leap year")
                        } else if year % 400 == 0 {
                            expect(date.leapYear).to(beTrue(), description: "year \(year) is divisable by 400 and is leap")
                        } else if year % 100 == 0 {
                            expect(date.leapYear).to(beFalse(), description: "year \(year) is divisable by 100 and is NOT leap")
                        } else if year % 4 == 0 {
                            expect(date.leapYear).to(beTrue(), description: "year \(year) is divisable by 4 and is leap")
                        } else {
                            expect(date.leapYear).to(beFalse(), description: "year \(year) is NOT divisable by 4 and is NOT leap")
                        }
                    }
                }
                
                // TODO: Leap tests for non-gregorian calendars

                it("should synchronise all locale assignments") {
                    let date = JHDate(year: 1999, month: 12, day: 31)!
                    expect(date.calendar.locale) == date.locale
                }

                it("should synchronise all time zone assignments") {
                    let date = JHDate(year: 1999, month: 12, day: 31)!
                    expect(date.calendar.timeZone) == date.timeZone
                }
            }

            context("conversions") {

                it("should convert to another calendar") {
                    let date = JHDate(year: 1999, month: 12, day: 31, calendar: NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian))!
                    let date2 = JHDate(refDate: date, calendar: NSCalendar(identifier: NSCalendarIdentifierHebrew))!

                    expect(date2.day) == 22
                    expect(date2.month) == 4
                    expect(date2.year) == 5760
                }
                
                it("should convert to another time zone") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 12, timeZone: NSTimeZone(abbreviation: "UTC"), calendar: gregorianCalendar)!
                    let date2 = JHDate(refDate: date, timeZone: NSTimeZone(abbreviation: "IST"))!

                    expect(date2.minute) == 30
                    expect(date2.hour) == 17
                    expect(date2.day) == 31
                    expect(date2.month) == 12
                    expect(date2.year) == 1999
                }
                
                it("should convert to another locale") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 12, calendar: gregorianCalendar, locale: NSLocale(localeIdentifier: "nl_NL"))!
                    let date2 = JHDate(refDate: date, calendar: gregorianCalendar, locale: NSLocale(localeIdentifier: "en_US"))!

                    expect(date2.toString(dateStyle: .MediumStyle)) == "Dec 31, 1999"
                }
                
            }

            context("descriptions") {

                var date: JHDate!
                beforeEach {
                    date = JHDate(year: 1999, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 500000000, calendar: NSCalendar(identifier: NSCalendarIdentifierGregorian), timeZone: NSTimeZone(abbreviation: "CET"), locale: NSLocale(localeIdentifier: "nl_NL"))!
                }

                it("Should output a proper description") {
                    let descriptions = date.description.componentsSeparatedByString(" ")

                    expect(descriptions[0]) == "Date"
                    expect(descriptions[1]) == "Fri"
                    expect(descriptions[2]) == "31-Dec-1999"
                    expect(descriptions[3]) == "AD"
                    expect(descriptions[4]) == "23:59:59.500"
                    expect(descriptions[5]) == "GMT+1"
                }
            }

            context("date formatter") {

                var date: JHDate!
                beforeEach {
                    date = JHDate(year: 1999, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 500000000, calendar: NSCalendar(identifier: NSCalendarIdentifierGregorian), timeZone: NSTimeZone(forSecondsFromGMT: 3600), locale: NSLocale(localeIdentifier: "nl_NL"))!
                }

                it("should initiate default date formatter") {
                    expect(date.toString()) == "31 dec. 1999 23:59:59"
                }

                it("should assign calendar properly") {
                    let testCalendar = NSCalendar(identifier: NSCalendarIdentifierBuddhist)!
                    let testDate = JHDate(refDate: date, calendar: testCalendar)!
                    expect(testDate.toString()) == "31 dec. 2542 BE 23:59:59"
                }

                it("should assign locale properly") {
                    let testLocale = NSLocale(localeIdentifier: "en_NZ")
                    let testDate = JHDate(refDate: date, locale: testLocale)!
                    expect(testDate.toString()) == "31/12/1999, 11:59:59 PM"
                }

                it("should assign time zone properly") {
                    let testTimeZone = NSTimeZone(abbreviation: "EST")!
                    let testDate = JHDate(refDate: date, timeZone: testTimeZone)!
                    expect(testDate.toString()) == "31 dec. 1999 17:59:59"
                }

                it("should return a proper string by default") {
                    let date = JHDate(year: 1999, month: 12, day: 31)!

                    let formatter = NSDateFormatter()
                    formatter.dateStyle = .MediumStyle
                    formatter.timeStyle = .MediumStyle
                    formatter.calendar = date.calendar
                    formatter.locale = date.locale
                    formatter.timeZone = date.timeZone

                    expect(date.toString(.MediumStyle)) == formatter.stringFromDate(date.date)
                }
                
                it("should return a proper string with specified locale") {
                    let date = JHDate(year: 1999, month: 12, day: 31, calendar: gregorianCalendar, locale: NSLocale(localeIdentifier: "uz_Cyrl_UZ"))!

                    expect(date.toString(dateStyle: .MediumStyle)) == "1999 Dek 31"
                }
                
                it("should return a proper string with specified calendar") {
                    let date = JHDate(year: 1999, month: 12, day: 31, calendar: NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian))!
                    let date2 = JHDate(refDate: date, calendar: NSCalendar(identifier: NSCalendarIdentifierHebrew))!

                    expect(date2.day) == 22
                    expect(date2.month) == 4
                    expect(date2.year) == 5760
                    expect(date2.toString(dateStyle: .MediumStyle)) == "AM 5760 Tevet 22"
                }
                
                it("should return a proper string with specified timezone") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 500000000, calendar: NSCalendar(identifier: NSCalendarIdentifierGregorian), timeZone: NSTimeZone(forSecondsFromGMT: 12345), locale: NSLocale(localeIdentifier: "nl_NL"))!

                    expect(date.toString(timeStyle: .LongStyle)) == "23:59:59 GMT+3:26"
                }
                
                it("should return a proper date string with relative conversion") {
                    let date = JHDate(locale: NSLocale(localeIdentifier: "fr_FR"))
                    let date2 = (date + 2.days)!
                    expect(date2.toRelativeString()) == "après-demain"
                }

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
                let testDate = date + 1.days
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
                let components = date1.difference(date2, unitFlags: [.Month, .Year])

                let expectedComponents = NSDateComponents()
                expectedComponents.month = 11
                expectedComponents.year = 1

                expect(components) == expectedComponents
            }

        }

        context("start of unit") {

            var date: JHDate!
            beforeEach {
                date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17, calendar: gregorianCalendar, locale: NSLocale(localeIdentifier: "nl_NL"))!
            }
            it("should return nil for nanosecond") {
                let testDate = date.startOf(.Nanosecond)
                expect(testDate).to(beNil())
            }
            
            it("should return nil for quarter") {
                let testDate = date.startOf(.Quarter)
                expect(testDate).to(beNil())
            }

            it("should return nil for week of month") {
                let testDate = date.startOf(.WeekOfMonth)
                expect(testDate).to(beNil())
            }

            it("should return start of second") {
                let testDate = date.startOf(.Second)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 31
                expect(testDate.hour) == 14
                expect(testDate.minute) == 15
                expect(testDate.second) == 16
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of minute") {
                let testDate = date.startOf(.Minute)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 31
                expect(testDate.hour) == 14
                expect(testDate.minute) == 15
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of hour") {
                let testDate = date.startOf(.Hour)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 31
                expect(testDate.hour) == 14
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of day") {
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
                date = date.startOf(.Day)
                let testDate = date.startOf(.Day)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 31
                expect(testDate.hour) == 0
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }

            it("should return start of week in Europe") {
                let testDate = date.startOf(.WeekOfYear)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 27
                expect(testDate.hour) == 0
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of year for week in Europe") {
                let testDate = date.startOf(.YearForWeekOfYear)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 1
                expect(testDate.day) == 4
                expect(testDate.hour) == 0
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of weekday") {
                let testDate = date.startOf(.Weekday)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 31
                expect(testDate.hour) == 0
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of week in USA") {
                let usaDate = JHDate(refDate: date, locale: NSLocale(localeIdentifier: "en_US"))!
                let testDate = usaDate.startOf(.WeekOfYear)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 12
                expect(testDate.day) == 26
                expect(testDate.hour) == 0
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of month") {
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
                let testDate = date.startOf(.Year)!

                expect(testDate.year) == 1999
                expect(testDate.month) == 1
                expect(testDate.day) == 1
                expect(testDate.hour) == 0
                expect(testDate.minute) == 0
                expect(testDate.second) == 0
                expect(testDate.nanosecond) == 0
            }
            
            it("should return start of era") {
                let testDate = date.startOf(.Era)!

                expect(testDate.year) == 1
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

        context("Copying") {
            it("should create a copy and not a reference") {
                let a = JHDate()
                let b = JHDate(refDate: a)!

                expect(a) == b
                expect(ObjectIdentifier(a)) != ObjectIdentifier(b)
            }
        }

        context("NSCoding") {
            it("should code and decode in a proper way") {

                let path = NSTemporaryDirectory() as NSString
                let fileLocation = path.stringByAppendingPathComponent("test")

                let sourceDate = JHDate()

                NSKeyedArchiver.archiveRootObject([sourceDate], toFile: fileLocation)

                let destinationDates = NSKeyedUnarchiver.unarchiveObjectWithFile(fileLocation) as? [JHDate]

                expect(destinationDates).notTo(beNil())
                expect(destinationDates!).to(haveCount(1))
                let date = destinationDates![0]
                expect(date) == sourceDate
                expect(date.calendar) == sourceDate.calendar
                expect(ObjectIdentifier(date)) != ObjectIdentifier(sourceDate)
            }
        }
}
    
}

