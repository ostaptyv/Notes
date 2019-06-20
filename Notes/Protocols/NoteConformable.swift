//
//  NoteConformable.swift
//  Notes
//
//  Created by user149331 on 6/20/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

protocol NoteConformable {
    var text: String { get }
    var time: String { get }
    var date: String { get }
    
    init(text: String)
    
    func update(withText text: String)
}
