//: Playground - noun: a place where people can play

import JHDate

let date = JHDate.now(NSTimeZone(abbreviation: "CEST"))
print(date)
print(date.date)
/*
date.timeZone = NSTimeZone(abbreviation: "EST")
print(date)
print(date.date)

let ethiopianDate = JHDate(date: date.date!,
    timeZone: NSTimeZone(abbreviation: "EAT"),
    calendar: NSCalendar(identifier: NSCalendarIdentifierEthiopicAmeteAlem))
print(ethiopianDate)
print(ethiopianDate.date)

print(date + 1.weeks)
print(date - 1.years)
print(date.filterUnits([.Year, .Month, .Day]))

print(date == ethiopianDate)
print(date.date == ethiopianDate.date)

date.year = 2020
print(date)
print(date.date)
*/
print("Start of week\n", date.startOf(.WeekOfYear))
print("End of week\n", date.endOf(.WeekOfYear))
