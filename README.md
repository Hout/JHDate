# JHDate

[![CI Status](http://img.shields.io/travis/Hout/JHDate.svg?style=flat)](https://travis-ci.org/Hout/JHDate)
[![Version](https://img.shields.io/cocoapods/v/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![License](https://img.shields.io/cocoapods/l/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![Platform](https://img.shields.io/cocoapods/p/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)

JHDate is a wrapper around NSDate that exposes the properties of NSDateComponents. Thus offering date functions with a flexibility that I was looking for:

- Use the object as an NSDate. I.e. as an absolute time.
- Offers all NSDateComponent vars & methods 
- Initialise a date with any combination of components
- Use default values for initialisation if desired
- Calendar & time zone can be changed, properties change along
- Default calendar is `NSCalendar.currentCalendar()`
- Default time zone is `NSTimeZone.localTimeZone()`
- Implements the Comparable protocol betwen dates with operators. E.g. `==, !=, <, >, <=, >=`
- implements date addition and subtraction operators with date components. E.g. `date + 2.days`

### Examples
```swift
// Create an empty date
let date = JHDate() 

// Create today's date
let today = JHDate.today()

// Create now
let now = JHDate.now()

// Create a determined date
let determinedDate = JHDate(year: 2011, month: 2, day: 11)

// One week later
let oneWeekLater = determinedDate + 1.weeks

// Compare
if determinedDate < oneWeekLater {
	print "Yes!"
}

print date 
// 
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8 is required.
The test code requires Quick and Nimble to be implemented. 

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
