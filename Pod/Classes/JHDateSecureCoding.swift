//
//  JHDateSecureCoding.swift
//  Pods
//
//  Created by Jeroen Houtzager on 02/11/15.
//
//

extension JHDate : NSSecureCoding {

    @objc public static func supportsSecureCoding() -> Bool {
        return true
    }

}