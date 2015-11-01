//
//  JHDateDescription.swift
//  Pods
//
//  Created by Jeroen Houtzager on 26/10/15.
//
//

import Foundation

// MARK: - CustomStringConvertable delegate

extension JHDate : CustomStringConvertible {

    /// Returns a full description of the class
    ///
    public var description: String {
        var descriptor: [String] = []

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee dd-MMM-yyyy GG HH:mm:ss.SSS zzz"
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        descriptor.append("Date \(dateFormatter.stringFromDate(self.date))")

        descriptor.append("Calendar: \(calendar)")
        descriptor.append("Time zone: \(timeZone)")

        return descriptor.joinWithSeparator("\n")
    }
    
}


