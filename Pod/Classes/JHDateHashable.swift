//
//  JHDateHashable.swift
//  Pods
//
//  Created by Jeroen Houtzager on 04/11/15.
//
//

extension JHDate {
    override public var hashValue: Int {
        return timeIntervalSinceReferenceDate.hashValue ^ calendar.hashValue ^ timeZone.hashValue ^ locale.hashValue
    }
}