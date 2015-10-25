//: Playground - noun: a place where people can play

import JHDate

// Create an empty date
let date = JHDate()
// Sun 25-Oct-2015 AD 22:56:28.363 GMT+1

// Create today's date
let today = JHDate.today()
// Sun 25-Oct-15 AD 00:00:00.000 GMT+2

// Create a determined date
let determinedDate = JHDate(year: 2011, month: 2, day: 11)!
// Fri 11-Feb-11 AD 00:00:00.000 GMT+1

// One week later
let oneWeekLater = (determinedDate + 1.weeks)!
// Fri 18-Feb-11 AD 00:00:00.000 GMT+1

// Create a new date based on another one with some different components
let newDate = oneWeekLater.withValue(14, forUnit: .Hour)
// Fri 18-Feb-11 AD 14:00:00.000 GMT+1

// ... or with a combination of components
let newDate2 = oneWeekLater.withValues([(13, .Hour), (12, .Minute)])
// Fri 18-Feb-11 AD 13:12:00.000 GMT+1

// Change the calendar
date.calendar = NSCalendar(identifier: NSCalendarIdentifierIndian)!
// Sun 03-Kartika-1937 Saka 22:56:28.363 GMT+1

// .. and the time zone
date.timeZone = NSTimeZone(abbreviation: "IST")!
// Mon 04-Kartika-1937 Saka 03:26:10.723 GMT+5:30

// Compare
if determinedDate < oneWeekLater {
    print("Yes!")                           // Yes!
}

