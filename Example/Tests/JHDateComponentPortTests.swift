//
//  JHDateComponentPortTests.swift
//  JHDate
//
//  Created by Jeroen Houtzager on 07/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//
// https://github.com/Quick/Quick


import Quick
import Nimble
import JHDate

class JHDateComponentPortSpec: QuickSpec {

    override func spec() {

        describe("JHDate") {

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
                    let date = JHDate(yearForWeekOfYear: 1492, weekOfYear: 15, weekday: 4, locale: localeNL)!

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

                    expect(date.year) == 1
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
                    let components = date.components
                    expect(components.year) == 1999
                    expect(components.month) == 12
                    expect(components.day) == 31
                    expect(components.timeZone) == timeZone
                }
                
            }
            
            context("Gregorian weekends") {

                it("should return a proper weekend value for a Saturday") {
                    let date = JHDate(year: 2015, month: 11, day: 7)!
                    expect(date.isInWeekend()) == true
                }

                it("should return a proper weekend value for a Sunday") {
                    let date = JHDate(year: 2015, month: 11, day: 8)!
                    expect(date.isInWeekend()) == true
                }

                it("should return a proper weekend value for a Monday") {
                    let date = JHDate(year: 2015, month: 11, day: 9)!
                    expect(date.isInWeekend()) == false
                }

                it("should return a proper weekend value for a Tuesday") {
                    let date = JHDate(year: 2015, month: 11, day: 10)!
                    expect(date.isInWeekend()) == false
                }

                it("should return a proper weekend value for a Wednesday") {
                    let date = JHDate(year: 2015, month: 11, day: 11)!
                    expect(date.isInWeekend()) == false
                }

                it("should return a proper weekend value for a Thursday") {
                    let date = JHDate(year: 2015, month: 11, day: 12)!
                    expect(date.isInWeekend()) == false
                }

                it("should return a proper weekend value for a Friday") {
                    let date = JHDate(year: 2015, month: 11, day: 13)!
                    expect(date.isInWeekend()) == false
                }

            }

        }
    }

}
