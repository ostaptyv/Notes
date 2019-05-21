//
//  CellNote.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import UIKit

class CellNote: UITableViewCell {
    static let reuseIdentifier = "CellNote"
    
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
