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
let usaDate = JHDate(year: 2011, month: 2, day: 11, hour: 14, timeZone: usaTimeZone)!

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

//: #### Conversions
//: Change time zone
newDate2.timeZone = usaTimeZone

//: Change and time zone calendar to Islamic in Dubai
newDate2.calendar = NSCalendar(identifier: NSCalendarIdentifierIslamicCivil)!
newDate2.timeZone = NSTimeZone(abbreviation: "GST")!

//: Again, but now we go to New Delhi
newDate2.calendar = NSCalendar(identifier: NSCalendarIdentifierIndian)!
newDate2.timeZone = NSTimeZone(abbreviation: "IST")!

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

date2.timeZone = NSTimeZone(abbreviation: "CST")!

//: date1 = 14:00 UTC
//: date2 = 9:00 CST
date1 > date2
date1 < date2

//: QED: same outcome!

//: #### Display
//: JHDate conforms to the ConvertString protocol
print(date2.description)

/*:

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 9 is required.
The test code requires Quick and Nimble to be implemented. You can do so by running ``pod install`` in the ``Examples`` folder.

## Installation

### Cocoapods
JHDate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JHDate"
```
### Manually
Get a git clone and add ``JHDate.swift`` to your project.

```shell
git clone https://github.com/Hout/JHDate.git
```


## Author

Jeroen Houtzager, pls contact me through GitHub

## License

JHDate is available under the MIT license. See the LICENSE file for more info.
*/