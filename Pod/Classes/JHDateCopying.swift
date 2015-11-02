//
//  JHDateCopying.swift
//  Pods
//
//  Created by Jeroen Houtzager on 01/11/15.
//
//


extension JHDate : NSCopying {

    @objc public func copyWithZone(zone: NSZone) -> AnyObject {
        let newObject = JHDate(date: self.date, calendar: self.calendar)
        return newObject
    }

}
