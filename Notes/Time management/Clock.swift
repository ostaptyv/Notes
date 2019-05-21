//
//  Clock.swift
//  Notes
//
//  Created by user149331 on 5/14/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import Foundation

class Clock {
    
    private var clock: Date {
        let secondsFromGMT = TimeInterval(TimeZone.current.secondsFromGMT())
        return Date().addingTimeInterval(secondsFromGMT)
    }
    
    var currentTime: String {
        return formTime(from: clock.description)
    }
    
    var currentDate: String {
        return formDate(from: clock.description)
    }
    
    func formTime(from string: String) -> String {
        var array = string.split(separator: " ")
        
        var time = [Character](array[1])
        for _ in 0..<3 { time.removeLast() }
        return String(time)
    }
    
    func formDate(from string: String) -> String {
        let date = string.split(separator: " ")[0]
        var array = date.split(separator: "-")
        array.reverse()
        
        return array.joined(separator: ".")
    }
}
