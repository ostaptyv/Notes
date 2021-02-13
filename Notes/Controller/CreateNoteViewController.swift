//
//  CreateNoteViewController.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 10.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        setupNavigationBar()
        scrollDownIfTextCrossOverKeyboard()
        
        textView.text = ""
        textView.becomeFirstResponder()
    }
    
    static func instance() -> CreateNoteViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! CreateNoteViewController
    }
    
    deinit {
        removeScrollDownIfTextCrossOverKeyboard()
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
        backViewController.database.addNote(note, toBeginning: backViewController.isSortNewToOld)
        backViewController.tableView.reloadData()
        
        backViewController.navigationController?.popViewController(animated: true)
    }
}

extension CreateNoteViewController {
    
    private func scrollDownIfTextCrossOverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
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
    
    private func removeScrollDownIfTextCrossOverKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
