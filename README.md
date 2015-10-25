# JHDate

[![CI Status](http://img.shields.io/travis/Hout/JHDate.svg?style=flat)](https://travis-ci.org/Hout/JHDate)
[![Version](https://img.shields.io/cocoapods/v/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![License](https://img.shields.io/cocoapods/l/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![Platform](https://img.shields.io/cocoapods/p/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)

JHDate is a wrapper around NSDate that exposes the properties of NSDateComponents. Thus offering date functions with a flexibility that I was looking for:

- Use the object as an NSDate. I.e. as an absolute time.
- Contains a date (NSDate), a calendar (NSCalendar) and a timeZone (NSTimeZone) property
- Offers all NSDate & NSDateComponent vars & methods
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

```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 9 is required.
The test code requires Quick and Nimble to be implemented. You can do so by running ``pod install`` in the ``Examples`` folder.

## Installation

JHDate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JHDate"
```

## Author

Jeroen Houtzager, pls contact me through GitHub

## License

JHDate is available under the MIT license. See the LICENSE file for more info.
