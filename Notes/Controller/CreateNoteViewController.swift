//
//  CreateNoteViewController.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        setupNavigationBar()
        
        textView.text = ""
        textView.becomeFirstResponder()
    }
    
    static func instance() -> CreateNoteViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! CreateNoteViewController
    }
}

extension CreateNoteViewController {
    private func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        let saveIcon = makeSaveIcon()
        self.navigationItem.rightBarButtonItem = saveIcon
    }
    
    private func makeSaveIcon() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTapped))
    }
    
    @objc private func saveTapped() {
        let backViewController = self.backViewController() as! NotesListViewController
        
        guard !textView.text.isEmpty else {
            backViewController.navigationController?.popViewController(animated: true)
            return print("Text of note is empty; No sense making the note")
        }
        
        let note = Note(text: textView.text)
        try! backViewController.realm.write {
            if backViewController.isSortNewToOld {
                backViewController.list.source.insert(note, at: 0)
            } else {
                backViewController.list.source.append(note)
            }
        }
        backViewController.tableView.reloadData()
        
        backViewController.navigationController?.popViewController(animated: true)
    }
}
