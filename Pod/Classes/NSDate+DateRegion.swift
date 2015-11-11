//
//  BNSDate+DateRegion.swift
//  Pods
//
//  Created by Jeroen Houtzager on 10/11/15.
//
//

extension NSDate {
    func region(aRegion: DateRegion? = nil) -> JHDate {
        return JHDate(date: self, region: aRegion)
    }
}