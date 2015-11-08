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

class JHDateEquationsTests: QuickSpec {

    override func spec() {

        describe("JHDateEquations") {

            it("should return true for equating a different object with the same properties") {
                let date1 = JHDate(year: 1999, month: 12, day: 31)!
                let date2 = date1

                expect(date1 == date2) == true
            }

            it("should return true for equating the same object") {
                let date1 = JHDate(year: 1999, month: 12, day: 31)!
                let date2 = date1

                expect(date1 == date2) == true
            }

            it("should return false for equating objects with different dates") {
                let date1 = JHDate(year: 1999, month: 12, day: 31)!
                let date2 = JHDate(year: 1999, month: 12, day: 30)!

                expect(date1 == date2) == false
            }

            it("should return false for equating objects with different calendars") {
                let date1 = JHDate(year: 1999, month: 12, day: 31, calendar: NSCalendar(identifier: NSCalendarIdentifierGregorian))!
                let date2 = JHDate(refDate: date1, calendar: NSCalendar(identifier: NSCalendarIdentifierChinese))

                expect(date1 == date2) == false
            }
            
            it("should return false for equating objects with different locales") {
                let date1 = JHDate(year: 1999, month: 12, day: 31, locale: NSLocale(localeIdentifier: "en_UK"))!
                let date2 = JHDate(refDate: date1, locale: NSLocale(localeIdentifier: "en_US"))
                
                expect(date1 == date2) == false
            }
            
        }

    }

        
}
