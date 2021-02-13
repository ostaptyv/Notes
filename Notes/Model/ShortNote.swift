//
//  ShortNote.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 10.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
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
