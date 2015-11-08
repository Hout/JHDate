//
//  JHDateEquationsTests.swift
//  JHDate
//
//  Created by Jeroen Houtzager on 07/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import JHDate

class JHDateHashableTests: QuickSpec {

    override func spec() {

        describe("JHDateHashable") {

            it("should return an equal hash for the same date reference") {
                let date1 = JHDate(year: 1999, month: 12, day: 31)!

                expect(date1.hashValue) == date1.hashValue
            }
            
            it("should return an equal hash for the same date value") {
                let date1 = JHDate(year: 1999, month: 12, day: 31)!
                let date2 = JHDate(year: 1999, month: 12, day: 31)!

                expect(date1.hashValue) == date2.hashValue
            }
            
            it("should return an unequal hash for a different date value") {
                let date1 = JHDate(year: 1999, month: 12, day: 31)!
                let date2 = JHDate(year: 1999, month: 12, day: 30)!

                expect(date1.hashValue) != date2.hashValue
            }
            
            it("should return an unequal hash for a different time zone value") {
                let date = NSDate()
                let date1 = JHDate(date: date, timeZone: NSTimeZone(abbreviation: "GMT"))
                let date2 = JHDate(date: date, timeZone: NSTimeZone(abbreviation: "CET"))

                expect(date1.hashValue) != date2.hashValue
            }
            
            it("should return an unequal hash for a different locale value") {
                let date = NSDate()
                let date1 = JHDate(date: date, locale: NSLocale(localeIdentifier: "en_AU"))
                let date2 = JHDate(date: date, locale: NSLocale(localeIdentifier: "en_NZ"))

                expect(date1.hashValue) != date2.hashValue
            }
            
            it("should return an unequal hash for a different calendar value") {
                let date = NSDate()
                let date1 = JHDate(date: date, calendar: NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamic))
                let date2 = JHDate(date: date, calendar: NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicCivil))

                expect(date1.hashValue) != date2.hashValue
            }
            

        }

    }

        
}
