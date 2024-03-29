//
//  DetailsViewController.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 11.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    private var row: Int!
    private var database: Database<Note> {
        return DatabaseRealm.shared
    }
    
    private var notesListViewController: NotesListViewController {
        return self.backViewController() as! NotesListViewController
    }
    
    private var currrentNote: Note {
        if notesListViewController.isFiltering {
            return notesListViewController.filteredNotes[row]
        } else {
            return database[row]!
        }
    }
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        scrollDownIfTextCrossOverKeyboard()
        
        textView.isEditable = false
        textView.text = currrentNote.text
    }
    
    // MARK: - Factory method for creating instances of the view controller
    
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
    
    // MARK: - Factory methods
    
    private func makeShareButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    private func makeEditButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editTapped))
    }
    
    private func makeDoneButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    // MARK: - Corresponding to button taps
    
    @objc private func shareTapped() {
        let activityView = UIActivityViewController(activityItems: [currrentNote.text], applicationActivities: [])
        present(activityView, animated: true)
        
    }
    
    @objc private func editTapped() {
        self.navigationItem.rightBarButtonItem = makeDoneButton()
        textView.isEditable = true
        textView.becomeFirstResponder()
    }
    
    @objc private func doneTapped() {
        self.navigationItem.rightBarButtonItem = makeEditButton()
        textView.isEditable = false
        
        database.updateNote(currrentNote, withText: textView.text)
        notesListViewController.tableView.reloadData()
    }
    
    // MARK: - Code which adjusts keyboard when the text view go out the frame view
    
    private func scrollDownIfTextCrossOverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
