# JHDate

[![CI Status](http://img.shields.io/travis/Hout/JHDate.svg?style=flat)](https://travis-ci.org/Hout/JHDate)
[![Version](https://img.shields.io/cocoapods/v/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![License](https://img.shields.io/cocoapods/l/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)
[![Platform](https://img.shields.io/cocoapods/p/JHDate.svg?style=flat)](http://cocoapods.org/pods/JHDate)

JHDate is a wrapper around NSDateComponents, offering date functions with a flexibility that I was looking for:

- Access date components as vars
- Initialise a date with any combination of components
- Use default values for initiailisation if desired
- Offers all NSDateComponent vars & methods 
- Default values include the current calendar and default time zone
- Implements the Comparable protocol betwen dates with operators. E.g. `==, !=, <, >, <=, >=`
- implements date addition and subtraction operators with date components. E.g. `date + 2.days`

### Examples
````swift
// Create an empty date
let date = JHDate() 

// Makes date components default to 1-Jan-2001 00:00:00.000 
// in hte local timezone and according to the current calendar
date.strictEvaluation = false 

print date 
// 
````

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8 is required.
The test code reuires Quick and Nimble to be implemented. 

## Installation

JHDate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JHDate"
```

## Author

Jeroen Houtzager, houtzager@gmail.com

## License

JHDate is available under the MIT license. See the LICENSE file for more info.
