//
//  NotesListViewController.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 10.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import UIKit
import RealmSwift

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var isSortNewToOld = true
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return true
        }
        return text.isEmpty
    }
    internal var filteredNotes = [Note]()
    internal var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var database: Database<Note> {
        return DatabaseRealm.shared
    }
    private var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let isSortNewToOldUncasted = userDefaults.value(forKey: .isSortNewToOldKey) {
            if let isSortNewToOld = isSortNewToOldUncasted as? Bool {
                self.isSortNewToOld = isSortNewToOld
            }
        } else {
            userDefaults.setValue(isSortNewToOld, forKey: .isSortNewToOldKey)
        }
        
        setupNavigationBar()
        setupSearchBar()
    }
    
    // MARK: - Factory method for creating instances of the view controller
    
    static func instance() -> UINavigationController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! UINavigationController
    }
    
    // MARK: - Methods to setup some specific UI
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let addIcon = makeAddIcon()
        let sortIcon = makeSortIcon()
        self.navigationItem.rightBarButtonItems = [addIcon, sortIcon]
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Factory methods
    
    private func makeAddIcon() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
    }
    
    private func makeSortIcon() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "sort icon"), style: .plain, target: self, action: #selector(sortTapped))
    }
    
    private func makeNewToOldAction(for tableView: UITableView) -> UIAlertAction {
        let result = UIAlertAction(title: "От новых к старым", style: .default) { [weak self] _ in
            self?.isSortNewToOld = true
            self?.reverseNotesCollection()
        }
        result.setValue(isSortNewToOld, forKey: "checked")
        
        return result
    }
    
    private func makeOldToNewAction(for tableView: UITableView) -> UIAlertAction {
        let result = UIAlertAction(title: "От старых к новым", style: .default) { [weak self] _ in
            self?.isSortNewToOld = false
            self?.reverseNotesCollection()
        }
        result.setValue(!isSortNewToOld, forKey: "checked")
        
        return result
    }
    
    private func makeCancelAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
    
    // MARK: - Corresponding to button taps
    
    @objc private func createNote() {
        let vc = CreateNoteViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func sortTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(makeNewToOldAction(for: self.tableView))
        alert.addAction(makeOldToNewAction(for: self.tableView))
        alert.addAction(makeCancelAction())
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        } else {
            return database.notesCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let shortNote: ShortNote
        if isFiltering {
            shortNote = ShortNote(from: filteredNotes[indexPath.row])
        } else {
            shortNote = ShortNote(from: database[indexPath.row]!)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesListTableViewCell.reuseIdentifier) as! NotesListTableViewCell
        cell.shortTextLabel.numberOfLines = 3
        
        cell.shortTextLabel.text = shortNote.text
        cell.dateLabel.text = shortNote.date + ", " + shortNote.time
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailsViewController.instance(forRow: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = makeDeleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func makeDeleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, completion in
            if self.isFiltering {
                let noteToDelete = self.filteredNotes.remove(at: indexPath.row)
                self.database.deleteNote(noteToDelete)
            } else {
                self.database.deleteNote(at: indexPath.row)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        
        return action
    }
    
    // MARK: - Reverse notes list
    
    private func reverseNotesCollection() {
        let userDefaultsIsSortNewToOld = userDefaults.bool(forKey: .isSortNewToOldKey)
        
        if self.isSortNewToOld != userDefaultsIsSortNewToOld {
            userDefaults.set(isSortNewToOld, forKey: .isSortNewToOldKey)
            
            database.reverseNotesCollection()
            tableView.reloadData()
        }
    }
    
    // MARK: - UISearchResultsUpdating protocol implementation
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredNotes = database.filterNotes { note -> Bool in
            return note.text.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        tableView.reloadData()
    }
}

extension String {
    static let isSortNewToOldKey = "isSortNewToOldKey"
}
