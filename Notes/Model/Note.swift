//
//  Note.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import RealmSwift

class Note: Object, NoteConformable {
    @objc dynamic var text = ""
    @objc dynamic var time = ""
    @objc dynamic var date = ""
    
    required convenience init(text: String) {
        self.init()
        
        self.text = text
        self.time = currentTime()
        self.date = currentDate()
    }
    
    func update(withText text: String) {
        self.text = text
        self.time = currentTime()
        self.date = currentDate()
    }
    
    private func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: Date())
    }
    
    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: Date())
    }
}
