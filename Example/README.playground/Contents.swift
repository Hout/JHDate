/*:

# JHDate

JHDate is a wrapper around NSDate that exposes the properties of NSDateComponents. Thus offering date functions with a flexibility that I was looking for:

- Use the object as an NSDate. I.e. as an absolute time.
- Contains a date (NSDate), a calendar (NSCalendar) and a timeZone (NSTimeZone) property
- Offers many NSDate, NSCalendar & NSDateComponent vars & funcs
- Initialise a date with many combinations of components
- Use default values for initialisation if desired
- Date is fixed, calendar & time zone can be changed, properties change along
- Implements the Comparable protocol betwen dates with operators. E.g. `==, !=, <, >, <=, >=`
- implements date addition and subtraction operators with date components. E.g. `date + 2.days`
- JHDate is immutable, so thread safe. It contains a constructor to easily create new ``JHDate`` occurrences with some properties adjusted.

### Examples
Check out the playground:
*/

import JHDate

//: #### Initialisers
//: Create a new date object with the current date & time alike NSDate()
let date = JHDate()

//: Create a determined date
let determinedDate = JHDate(year: 2011, month: 2, day: 11)!

//: Create a determined date in a different time zone
let usaTimeZone = NSTimeZone(abbreviation: "EST")!
var usaDate = JHDate(year: 2011, month: 2, day: 11, hour: 14, timeZone: usaTimeZone)!

//: Mind that default values for JHDate(year etc) are taken from the reference date,
//: which is 1 January 2001, 00:00:00.000 in your default time zone and against your current calendar.

//: Week oriented initiailisations are also possible: first week of 2016:
let weekDate = JHDate(yearForWeekOfYear: 2016, weekOfYear: 1, weekday: 1)!
//: In Europe this week starts in 2015 despite the year for the week that is 2016.
//: That is because the Thursday of this week is in 2016 as specified by ISO 8601

//: Create a determined date in a different calendar
let hebrewCalendar = NSCalendar(identifier: NSCalendarIdentifierHebrew)
let hebrewDate = JHDate(year: 2011, month: 2, day: 11, hour: 14, calendar: hebrewCalendar)!

//: Create today's date
let today = JHDate.today()

//: #### Calculations
//: One week later
let oneWeekLater = (determinedDate + 1.weeks)!

//: Twelve hours earlier
let earlier = (determinedDate - 12.hours)!

//: Or combinations
let something = ((determinedDate - 12.hours)! + 30.minutes)!

//: Create a new date based on another one with some different components
let newDate = oneWeekLater.withValue(14, forUnit: .Hour)!

//: ... or with a combination of components
let newDate2 = oneWeekLater.withValues([(13, .Hour), (12, .Minute)])!

//: #### NSDate
newDate.timeIntervalSinceReferenceDate
JHDate.earliestDate(newDate, newDate2, today, something)
JHDate.latestDate(newDate, newDate2, today, something)

//: #### Components
newDate2.year
newDate2.month
newDate2.day

newDate2.yearForWeekOfYear
newDate2.weekOfYear
newDate2.weekday

newDate2.hour
newDate2.minute
newDate2.second

//: #### StartOF & EndOF
//: Create new dates based on this week's start & end
let startOfWeek = newDate.startOf(.WeekOfYear)
let endOfWeek = newDate.endOf(.WeekOfYear)

//: Create new dates based on this day's start & end
let startOfDay = newDate.startOf(.Day)
let endOfDay = newDate.endOf(.Day)

//: Create new dates based on this day's start & end
let startOfYear = newDate.startOf(.Year)
let endOfYear = newDate.endOf(.Year)

//: #### Conversions
//: Change time zone
let usaDate2 = JHDate(refDate: newDate2, timeZone: usaTimeZone)

//: Change and time zone calendar to Islamic in Dubai
let dubaiTimeZone = NSTimeZone(abbreviation: "GST")!
let dubaiCalendar = NSCalendar(identifier: NSCalendarIdentifierIslamicCivil)!
let dubaiDate = JHDate(refDate: newDate2, calendar: dubaiCalendar, timeZone: dubaiTimeZone)

//: Again, but now we go to New Delhi
let indiaTimeZone = NSTimeZone(abbreviation: "IST")!
let indiaCalendar = NSCalendar(identifier: NSCalendarIdentifierIndian)!
let indiaDate = JHDate(refDate: newDate2, calendar: dubaiCalendar, timeZone: dubaiTimeZone)

//: #### Equations
//: JHDate conforms to the Equatable protocol. I.e. you can compare with == for equality.
newDate == newDate2
newDate == newDate

//: For equal date values, you should use x.isEqualToDate(y)
let newDate3 = JHDate(refDate: newDate2)!
newDate == newDate3
let newDate4  = JHDate(refDate: newDate2, locale: NSLocale(localeIdentifier: "en_NZ"))!
newDate4 == newDate3
newDate.isEqualToDate(newDate3)
newDate2.toString()
newDate3.toString()
newDate4.toString()

//: #### Comparisons
//: JHDate conforms to the Comparable protocol. I.e. you can compare with <. <=, ==, >=, >
newDate > newDate2
newDate >= newDate2
newDate == newDate2
newDate != newDate2
newDate <= newDate2
newDate < newDate2

//: Mind that comparisons takes the absolute time from the date property into account.
//: calendars and time zones have no effect on the comparison results.
let date1 = JHDate(year: 2000, month: 1, day: 1, hour: 14, timeZone: NSTimeZone(abbreviation: "UTC"))!
let date2 = (date1 + 1.hours)!

//: date1 = 14:00 UTC
//: date2 = 15:00 UTC
date1 > date2
date1 < date2

let indiaDate1 = JHDate(refDate: date1, calendar: indiaCalendar, timeZone: indiaTimeZone)!

//: indiaDate1 = 19:30 IST
//: date1 = 14:00 UTC
//: date2 = 9:00 CST
indiaDate1 > date2
indiaDate1 < date2

indiaDate1.isEqualToDate(date1)

//: QED: same outcome!

//: #### Display
//: JHDate conforms to the ConvertString protocol
date2.description

//: Various NSDateFormatter properties are ported
let date3 = (date1 + 7.hours)!
date3.toString()
date3.toString(.LongStyle)
date3.toString(dateStyle: .LongStyle)
date3.toString(timeStyle: .LongStyle)
date3.toString("dd-MMM-yyyy HH:mm")
(JHDate() + 1.days)!.toRelativeString()




