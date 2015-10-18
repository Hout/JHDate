//: Playground - noun: a place where people can play

import UIKit
import JHDate

let date1 = NSDate()
let date2 = NSDate(year: 2015, month: 8, day: 20)!
let date3 = date2.withValue(2014, forUnit: .Year)
date2.toString()
