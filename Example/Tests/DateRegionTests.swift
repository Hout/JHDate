//
//  DateRegionTests.swift
//  JHDate
//
//  Created by Jeroen Houtzager on 10/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//
// https://github.com/Quick/Quick


import Quick
import Nimble
import JHDate

class DateregionSpec: QuickSpec {

    override func spec() {

        describe("DateRegion") {

            context("initialisation") {

                it("should have the default time zone in the current calendar") {
                    let region = DateRegion()

                    expect(region.calendar) == NSCalendar.currentCalendar()
                    expect(region.timeZone) == NSTimeZone.defaultTimeZone()
                    expect(region.locale) == NSLocale.currentLocale()
                    expect(region.calendar.timeZone) == NSTimeZone.defaultTimeZone()
                    expect(region.calendar.locale) == NSLocale.currentLocale()
                }

                it("should have the specified calendar") {
                    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierHebrew)
                    let region = DateRegion(calendar: calendar)

                    expect(region.calendar) == calendar
                }

                it("should have the specified time zone") {
                    let timeZone = NSTimeZone(abbreviation: "IST")
                    let region = DateRegion(timeZone: timeZone)

                    expect(region.timeZone) == timeZone
                }

                it("should have the specified locale") {
                    let locale = NSLocale(localeIdentifier: "cat_IT")
                    let region = DateRegion(locale: locale)

                    expect(region.locale) == locale
                }
            }
        }
    }
}

