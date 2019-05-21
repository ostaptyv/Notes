//
//  Note.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import RealmSwift

class Note: Object {
    @objc dynamic var text = ""
    @objc dynamic var time = ""
    @objc dynamic var date = ""
    
    convenience init(text: String) {
        self.init()
        
        self.text = text
        let clock = Clock()
        self.time = clock.currentTime
        self.date = clock.currentDate
    }
}
