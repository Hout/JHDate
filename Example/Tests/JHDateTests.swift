//
//  JHDateSpec.swift
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

        describe("NSDateComponents") {

            context("Calendar & time zone") {

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

            }

            context("Initialisation") {

                it("should return the reference date if initialised with interval 0") {
                    let UTCTimeZone = NSTimeZone(forSecondsFromGMT: 0)
                    let date = JHDate(timeSinceReferenceDate: 0, timeZone: UTCTimeZone)

                    expect(date.year) == 2001
                    expect(date.month) == 1
                    expect(date.day) == 1
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                    expect(date.timeZone) == UTCTimeZone
                    expect(date.calendar) == NSCalendar.currentCalendar()
                }

                it("should return 1-Jan-2001 00:00:00.000 date for nil initialisation") {
                    let UTCTimeZone = NSTimeZone(forSecondsFromGMT: 0)
                    let date = JHDate(timeZone: UTCTimeZone)

                    expect(date.year) == 2001
                    expect(date.month) == 1
                    expect(date.day) == 1
                    expect(date.yearForWeekOfYear) == 2001
                    expect(date.weekOfYear) == 1
                    expect(date.weekday) == 2
                    expect(date.hour) == 0
                    expect(date.minute) == 0
                    expect(date.second) == 0
                    expect(date.nanosecond) == 0
                    expect(date.timeZone) == UTCTimeZone
                    expect(date.calendar) == NSCalendar.currentCalendar()
                }
                

                it("should return a 123 date for YMD initialisation") {
                    let date = JHDate(year: 1999, month: 12, day: 31)

                    expect(date.year) == 1999
                    expect(date.month) == 12
                    expect(date.day) == 31
                }
                
                it("should return a 123 date for YWD initialisation") {
                    let date = JHDate(yearForWeekOfYear: 2016, weekOfYear: 1, weekday: 1)

                    expect(date.yearForWeekOfYear) == 2016
                    expect(date.weekOfYear) == 1
                    expect(date.weekday) == 1
                }

                it("should return a 123 date for component initialisation") {
                    let components = NSDateComponents()
                    components.month = 6
                    components.day = 3
                    let date = JHDate(components: components)
                    date.strictEvaluation = true

                    expect(date.year).to(beNil())
                    expect(date.month) == 6
                    expect(date.day) == 3
                }

                it("should return an exact copy on a jhdate init") {
                    let date = JHDate.now()
                    let dateCopy = JHDate(date: date)

                    expect(date.year) == dateCopy.year
                    expect(date.month) == dateCopy.month
                    expect(date.day) == dateCopy.day
                    expect(date.hour) == dateCopy.hour
                    expect(date.minute) == dateCopy.minute
                    expect(date.second) == dateCopy.second
                    expect(date.nanosecond) == dateCopy.nanosecond
                    expect(date.yearForWeekOfYear) == dateCopy.yearForWeekOfYear
                    expect(date.weekOfYear) == dateCopy.weekOfYear
                    expect(date.weekday) == dateCopy.weekday
                    expect(date.calendar) == dateCopy.calendar
                    expect(date.timeZone) == dateCopy.timeZone
                    expect(date.strictEvaluation) == dateCopy.strictEvaluation
                    expect(date.date) == dateCopy.date
                }

                it("should return a proper date") {
                    let date = JHDate(year: 1999, month: 12, day: 31)
                    let components = NSDateComponents()
                    components.year = 1999
                    components.month = 12
                    components.day = 31
                    let expectedDate = date.calendar!.dateFromComponents(components)

                    expect(date.date) == expectedDate
                }

            }

            context("unit operations") {

                var date: JHDate!
                var dateCopy: JHDate!
                beforeEach {
                    date = JHDate.now()
                    date.strictEvaluation = true
                    dateCopy = JHDate(date: date)
                }

                it("should return full units when filter is open") {
                    let filteredDate = date.filterUnits(NSCalendarUnit(rawValue: UInt.max))
                    expect(filteredDate) == dateCopy
                }

                it("should return no units when filter is closed") {
                    let filteredDate = date.filterUnits(NSCalendarUnit(rawValue: 0))

                    expect(filteredDate.strictEvaluation) == true
                    expect(filteredDate.year).to(beNil())
                    expect(filteredDate.month).to(beNil())
                    expect(filteredDate.day).to(beNil())
                    expect(filteredDate.hour).to(beNil())
                    expect(filteredDate.minute).to(beNil())
                    expect(filteredDate.second).to(beNil())
                    expect(filteredDate.nanosecond).to(beNil())
                    expect(filteredDate.yearForWeekOfYear).to(beNil())
                    expect(filteredDate.weekOfYear).to(beNil())
                    expect(filteredDate.weekday).to(beNil())
                    expect(filteredDate.calendar).to(beNil())
                    expect(filteredDate.timeZone).to(beNil())
                    expect(filteredDate.date).to(beNil())
                }

                it("should return filtered units when filtered") {
                    let filteredDate = date.filterUnits(NSCalendarUnit.Second)
                    expect(filteredDate) != dateCopy
                    expect(filteredDate.second) == dateCopy.second
                }

                // TODO: definedUnits
            }

            context("date evaluation") {

                it("should return all nils with a default date and strict = true") {
                    let date = JHDate()
                    date.strictEvaluation = true

                    expect(date.year).to(beNil())
                    expect(date.month).to(beNil())
                    expect(date.day).to(beNil())
                    expect(date.hour).to(beNil())
                    expect(date.second).to(beNil())
                    expect(date.nanosecond).to(beNil())
                    expect(date.yearForWeekOfYear).to(beNil())
                    expect(date.weekOfYear).to(beNil())
                    expect(date.weekday).to(beNil())
                    expect(date.calendar).to(beNil())
                    expect(date.timeZone).to(beNil())
                }
                
                it("should return no nils with a default date and strict = false") {
                    let date = JHDate()
                    date.strictEvaluation = false

                    expect(date.year).toNot(beNil())
                    expect(date.month).toNot(beNil())
                    expect(date.day).toNot(beNil())
                    expect(date.hour).toNot(beNil())
                    expect(date.second).toNot(beNil())
                    expect(date.nanosecond).toNot(beNil())
                    expect(date.yearForWeekOfYear).toNot(beNil())
                    expect(date.weekOfYear).toNot(beNil())
                    expect(date.weekday).toNot(beNil())
                    expect(date.calendar).toNot(beNil())
                    expect(date.timeZone).toNot(beNil())
                }
                
                it("should return YMD and otherwise nils with today and strict = true") {
                    let date = JHDate.today()
                    date.strictEvaluation = true

                    expect(date.year).toNot(beNil())
                    expect(date.month).toNot(beNil())
                    expect(date.day).toNot(beNil())
                    expect(date.hour).to(beNil())
                    expect(date.second).to(beNil())
                    expect(date.nanosecond).to(beNil())
                    expect(date.yearForWeekOfYear).to(beNil())
                    expect(date.weekOfYear).to(beNil())
                    expect(date.weekday).to(beNil())
                    expect(date.calendar).toNot(beNil())
                    expect(date.timeZone).toNot(beNil())
                }
                
            }


            context("class func") {

                it("should return a proper current date for today") {
                    let today = JHDate.today()
                    let expectedDate = NSDate()

                    expect(today.date!.timeIntervalSinceReferenceDate) ≈ (expectedDate.timeIntervalSinceReferenceDate, 3600*24)
                }
                
                it("should return a proper current date for now") {
                    let today = JHDate.now()
                    let expectedDate = NSDate()

                    expect(today.date!.timeIntervalSinceReferenceDate) ≈ (expectedDate.timeIntervalSinceReferenceDate, 1)
                }
                
            }

            context("comparisons") {


                it("should return true for equal comparing equals") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)
                    let date2 = JHDate(year: 1999, month: 12, day: 31)

                    expect(date1 == date2) == true
                }

                it("should return false for equal comparing unequals") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date1 == date2) == false
                }

                it("should return true for greater than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

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
                    let date1 = JHDate(year: 1999, month: 12, day: 29)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date1 < date2) == true
                }

                it("should return false for less than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date2 < date2) == false
                }

                it("should return false for less than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 29)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)
                    
                    expect(date2 < date1) == false
                }

                it("should return true for greater-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date1 >= date2) == true
                }

                it("should return false for greater-equal than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date2 >= date2) == true
                }

                it("should return false for greater-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 31)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date2 >= date1) == false
                }

                it("should return true for less-equal than comparing") {
                    let date1 = JHDate(year: 1999, month: 12, day: 29)
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

                    expect(date1 <= date2) == true
                }

                it("should return false for less-equal than comparing") {
                    let date2 = JHDate(year: 1999, month: 12, day: 30)

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
                    let date = JHDate(year: 1999, month: 12, day: 31)
                    print(date)
                    let testDate = date + 1.days
                    print(testDate)
                    let expectedDate = JHDate(year: 2000, month: 1, day: 1)

                    expect(testDate) == expectedDate
                }
                
                it("should add properly") {
                    let date = JHDate(year: 1999, month: 12, day: 31)
                    let testDate = (date + 1.weeks)!

                    expect(testDate.year) == 2000
                    expect(testDate.month) == 1
                    expect(testDate.day) == 7
                }
                
                it("should subtract properly") {
                    let date = JHDate(year: 2000, month: 1, day: 1)
                    let testDate = date - 1.days
                    let expectedDate = JHDate(year: 1999, month: 12, day: 31)

                    expect(testDate) == expectedDate
                }
                
                it("should differ properly") {
                    let date1 = JHDate(year: 2001, month: 2, day: 1)
                    let date2 = JHDate(year: 2003, month: 1, day: 10)
                    let components = date1.difference(date2, unitFlags: [.Month, .Year])

                    let expectedComponents = NSDateComponents()
                    expectedComponents.month = 11
                    expectedComponents.year = 1

                    expect(components) == expectedComponents
                }
                
            }

            context("start of unit") {

                it("should return start of day") {
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)
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
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)
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
                    let date = JHDate(year: 1999, month: 12, day: 31, hour: 14, minute: 15, second: 16, nanosecond: 17)
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
                    let date = JHDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)
                    let testDate = date.endOf(.Day)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 1
                    expect(testDate.day) == 1
                    expect(testDate.hour) == 23
                    expect(testDate.minute) == 59
                    expect(testDate.second) == 59
                    expect(testDate.nanosecond) == 999999999
                }

                it("should return end of month") {
                    let date = JHDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)
                    let testDate = date.endOf(.Month)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 1
                    expect(testDate.day) == 31
                    expect(testDate.hour) == 23
                    expect(testDate.minute) == 59
                    expect(testDate.second) == 59
                    expect(testDate.nanosecond) == 999999999
                }

                it("should return end of year") {
                    let date = JHDate(year: 1999, month: 1, day: 1, hour: 14, minute: 15, second: 16, nanosecond: 17)
                    let testDate = date.endOf(.Year)!

                    expect(testDate.year) == 1999
                    expect(testDate.month) == 12
                    expect(testDate.day) == 31
                    expect(testDate.hour) == 23
                    expect(testDate.minute) == 59
                    expect(testDate.second) == 59
                    expect(testDate.nanosecond) == 999999999
                }
                
            }
        }
        
    }
    
}
