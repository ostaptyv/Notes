//
//  NoteProtocol.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 20.06.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

protocol NoteProtocol {
    var text: String { get }
    var time: String { get }
    var date: String { get }
    
    init(text: String)
    
    func update(withText text: String)
}
