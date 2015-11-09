//
//  JHDateHashable.swift
//  Pods
//
//  Created by Jeroen Houtzager on 04/11/15.
//
//

extension JHDate : Hashable {
    public var hashValue: Int {
        return date.hashValue ^ calendar.hashValue ^ timeZone.hashValue ^ locale.hashValue
    }
}