//
//  DatabaseRealm.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 20.06.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import RealmSwift

class DatabaseRealm: Database<Note> {
    private let realm: Realm
    private let notes: NotesList
    
    static let shared = DatabaseRealm()
    
    override var notesCount: Int {
        return notes.list.count
    }
    
    override subscript(_ number: Int) -> Note? {
        guard number >= 0 && number < notesCount else {
            print("Database (subscript): Index out of range")
            return nil
        }
        return notes.list[number]
    }
    
    override func reverseNotesCollection() {
        try! realm.write {
            notes.list.reverse()
        }
    }
    
    override func filterNotes(_ isIncluded: (Note) -> Bool) -> [Note] {
        return notes.list.filter(isIncluded)
    }
    
    override func deleteNote(at index: Int) {
        try! self.realm.write {
            self.notes.list.remove(at: index)
        }
    }
    
    override func deleteNote(_ note: Note) {
        for i in 0..<notes.list.count {
            let note = notes.list[i]
            if note.isSameObject(as: note) {
                deleteNote(at: i)
                break
            }
        }
    }
    
    override func addNote(_ note: Note, toBeginning isOrderAscending: Bool) {
        try! realm.write {
            if isOrderAscending {
                notes.list.insert(note, at: 0)
            } else {
                notes.list.append(note)
            }
        }
    }
    
    override func updateNote(_ note: Note, withText text: String) {
        try! realm.write {
            note.update(withText: text)
        }
    }
    
    private override init() {
        // Create Realm instance
        let realm = try! Realm()
        
        // If there isn't a NotesList instance in the Realm then instantiate one:
        if realm.objects(NotesList.self).count == 0 {
            try! realm.write {
                realm.add(NotesList())
            }
        }
        
        self.notes = realm.objects(NotesList.self).first!
        self.realm = realm
    }
}
