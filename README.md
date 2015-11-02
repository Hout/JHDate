# JHDate

[![Build Status](https://travis-ci.org/Hout/JHDate.svg?branch=master)](https://travis-ci.org/Hout/JHDate)
[![Inline docs](http://inch-ci.org/github/Hout/JHDate.svg)](http://inch-ci.org/github/Hout/JHDate)
[![Version](https://img.shields.io/cocoapods/v/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![License](https://img.shields.io/cocoapods/l/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![Platform](https://img.shields.io/cocoapods/p/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)

JHDate is a wrapper around NSDate that exposes the properties of NSDateComponents, NSCalendar, NSTimeZone, NSLocale and NSDateFormatter. We are not there yet, but the intention is to replace your occurrence of NSDate with JHDate and get the same functionality plus lots of local date/calendar/time zone/formatter goodies. Thus offering date functions with a flexibility that I was looking for when creating this library:

- Use the object as an NSDate. I.e. as an absolute time. 
- Contains a date (NSDate), a calendar (NSCalendar), a locale (NSLocale) and a timeZone (NSTimeZone) property
- Offers many NSDate & NSDateComponent vars & methods
- Initialise a date with any combination of components
- Use default values for initialisation if desired
- Calendar & time zone can be changed, properties change along
- Default date is `NSDate()`
- Default calendar is `NSCalendar.currentCalendar()`
- Default time zone is `NSTimeZone.localTimeZone()`
- Implements the Comparable protocol betwen dates with operators. E.g. `==, !=, <, >, <=, >=`
- implements date addition and subtraction operators with date components. E.g. `date + 2.days`

### Examples
Check out the playground:

```swift
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

//: Various NSDateFormatter properties are ported
let date3 = (date1 + 7.hours)!
date3.timeZone = NSTimeZone(abbreviation: "UTC")!
date3.dateStyle = .ShortStyle
date3.toString()
date3.dateStyle = .MediumStyle
date3.toString()
date3.dateStyle = .LongStyle
date3.toString()
date3.dateStyle = .NoStyle
date3.toString()
date3.timeStyle = .ShortStyle
date3.toString()
date3.timeStyle = .MediumStyle
date3.toString()
date3.timeStyle = .LongStyle
date3.toString()
date3.timeStyle = .NoStyle
date3.toString()
date3.dateFormat = "dd-MMM-yyyy HH:mm"
date3.toString()


```

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
### Manual
Get a git clone and add ``JHDate.swift`` to your project.

```shell
git clone https://github.com/Hout/JHDate.git
```

## Design Decisions
I have taken the following decisions when setting up the library. I welcome  feedback on them.

Decision | Rationale
------------- | -------------
Do not include an initialiser from string  | That is too complicated with all the different ways of notation in the world. It would have too little benefit next to the currently available convenience intialisers instead.
Do not attempt to mimic all properties and functions of the NSDateFormatter, NSDateComponents etc. E.g. NSDateFormatter's ``localizedStringFromDate`` or ``weekdaySymbols`` | Sometimes it is just easier to use the ``date`` property from ``JHDate`` instead.
Equation ``==`` is on date values only | Hmmm, not sure about this one. Created an issue.

## Author

Jeroen Houtzager, pls contact me through GitHub

## Collaboration

if you would like to contribute:

- Fork
- Send pull requests
- Submit issues
- Challenge the design decisions
- Challenge coding
- Challenge anything!

These libs & authors inspired me to this code:

- [SwiftDate](https://github.com/malcommac/SwiftDate) from Daniele Margutti. I recommend this one if you are looking for a plain Swift NSDate extension.


## License

JHDate is available under the MIT license. See the LICENSE file for more info.
