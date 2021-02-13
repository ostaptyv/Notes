//
//  NotesList.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 10.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import RealmSwift

class NotesList: Object {
    var list = List<Note>()
}
