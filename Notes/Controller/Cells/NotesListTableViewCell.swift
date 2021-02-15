//
//  NotesListTableViewCell.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 10.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import UIKit

class NotesListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotesListTableViewCell"
    
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
