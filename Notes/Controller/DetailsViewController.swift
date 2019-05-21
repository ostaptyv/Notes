//
//  DetailsViewController.swift
//  Notes
//
//  Created by user149331 on 5/11/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    private var row: Int!
    
    private var backViewController: NotesListViewController {
        return self.backViewController() as! NotesListViewController
    }
    
    private var currrentNote: Note {
        if backViewController.isFiltering {
            return backViewController.filteredNotes[row]
        } else {
            return backViewController.list.source[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        textView.isEditable = false
        textView.text = currrentNote.text
    }
    
    static func instance(forRow row: Int) -> DetailsViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! DetailsViewController
        vc.row = row
        return vc
    }
    
    private func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        let editIcon = makeEditButton()
        let shareIcon = makeShareButton()
        self.navigationItem.rightBarButtonItems = [editIcon, shareIcon]
    }
}

extension DetailsViewController {
    private func makeShareButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc private func shareTapped() {
        let activityView = UIActivityViewController(activityItems: [currrentNote.text], applicationActivities: [])
        present(activityView, animated: true)
        
    }
}

extension DetailsViewController {
    private func makeEditButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editTapped))
    }
    
    @objc private func editTapped() {
        self.navigationItem.rightBarButtonItem = makeDoneButton()
        textView.isEditable = true
        textView.becomeFirstResponder()
    }
}

extension DetailsViewController {
    private func makeDoneButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    @objc private func doneTapped() {
        self.navigationItem.rightBarButtonItem = makeEditButton()
        textView.isEditable = false
        
        try! backViewController.realm.write {
            currrentNote.text = textView.text
            currrentNote.time = Clock().currentTime
            currrentNote.date = Clock().currentDate
        }
        
        backViewController.tableView.reloadData()
    }
}
