//
//  ShortNote.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

class ShortNote {
    var text: String
    var time: String
    var date: String
    
    init(text: String, time: String, date: String) {
        self.time = time
        self.date = date
        
        if text.count > 100 {
            let array = [Character](text)
            self.text = String(array[0..<100]) + "..."
        } else {
            self.text = text
        }
    }
    
    convenience init(from note: NoteConformable) {
        self.init(text: note.text, time: note.time, date: note.date)
    }
}
