//
//  Database.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 20.06.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import RealmSwift

class Database {
    private let realm = try! Realm()
    private var notes: NotesList!
    
    var notesCount: Int {
        return notes.list.count
    }
    
    subscript (_ number: Int) -> Note? {
        guard number >= 0 && number < notesCount else {
            print("Database (subscript): Index out of range")
            return nil
        }
        return notes!.list[number]
    }
    
    func reverseNotesCollection() {
        try! realm.write {
            notes.list.reverse()
        }
    }
    
    func filterNotes(_ isIncluded: (Note) -> Bool) -> [Note] {
        return notes.list.filter(isIncluded)
    }
    
    func deleteNote(at index: Int) {
        try! self.realm.write {
            self.notes.list.remove(at: index)
        }
    }
    
    func deleteNote(forReference reference: Note) {
        for i in 0..<notes.list.count {
            let note = notes.list[i]
            if note.isSameObject(as: reference) {
                deleteNote(at: i)
                break
            }
        }
    }
    
    func addNote(_ note: Note, toBeginning isOrderAscending: Bool) {
        try! realm.write {
            if isOrderAscending {
                notes.list.insert(note, at: 0)
            } else {
                notes.list.append(note)
            }
        }
    }
    
    func updateNote(text: String, forNote note: Note) {
        try! realm.write {
            note.update(withText: text)
        }
    }
    
    private func bindNotesListToRealm() {
        let numberOfObjects = realm.objects(NotesList.self).count
        if numberOfObjects == 0 {
            try! realm.write {
                realm.add(NotesList())
            }
        }
        notes = realm.objects(NotesList.self).first!
    }
    
    init() {
        bindNotesListToRealm()
    }
}
