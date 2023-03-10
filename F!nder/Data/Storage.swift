//
//  Storage.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/16.
//

import Foundation

class Storage {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey: "isFirstTime")
            return true
        } else {
            return false
        }
    }
}
