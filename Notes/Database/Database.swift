//
//  Database.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 15.02.2021.
//  Copyright © 2021 OstapTyvonovych. All rights reserved.
//

// Abstract class. Should be subclassed, t's not intended to use "as is"
class Database<Item: NoteProtocol> {
    var notesCount: Int {
        throwFatalError()
    }
    
    subscript(_ number: Int) -> Item? {
        throwFatalError()
    }
    
    func reverseNotesCollection() {
        throwFatalError()
    }
    func filterNotes(_ isIncluded: (Item) -> Bool) -> [Item] {
        throwFatalError()
    }
    func deleteNote(at index: Int) {
        throwFatalError()
    }
    func deleteNote(_ note: Item) {
        throwFatalError()
    }
    func addNote(_ note: Item, toBeginning isOrderAscending: Bool) {
        throwFatalError()
    }
    func updateNote(_ note: Item, withText text: String) {
        throwFatalError()
    }
    
    private func throwFatalError(file: StaticString = #file, line: UInt = #line) -> Never {
        return fatalError("Should be overriden in child class", file: file, line: line)
    }
}
