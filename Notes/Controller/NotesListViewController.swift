//
//  NotesListViewController.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import UIKit
import RealmSwift

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    var isSortNewToOld = true
    
    let realm = try! Realm()
    var list: NotesList!
    var filteredNotes = [Note]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavigationBar()
        setupSearchBar()
        
        bindListToRealm()
    }
    
    static func instance() -> UINavigationController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! UINavigationController
    }
    
    private func bindListToRealm() {
        let numberOfObjects = realm.objects(NotesList.self).count
        if numberOfObjects == 0 {
            try! realm.write {
                realm.add(NotesList())
            }
        }
        list = realm.objects(NotesList.self).first!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailsViewController.instance(forRow: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotesListViewController {
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let addIcon = makeAddIcon()
        let sortIcon = makeSortIcon()
        self.navigationItem.rightBarButtonItems = [addIcon, sortIcon]
    }
    
    private func makeAddIcon() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
    }
    
    @objc private func createNote() {
        let vc = CreateNoteViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotesListViewController {
    private func makeSortIcon() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "sort icon"), style: .plain, target: self, action: #selector(sortTapped))
    }
    
    @objc private func sortTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(makeNewToOldAction(for: self.tableView))
        alert.addAction(makeOldToNewAction(for: self.tableView))
        alert.addAction(makeCancelAction())
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func makeNewToOldAction(for tableView: UITableView) -> UIAlertAction {
        return UIAlertAction(title: "От новых к старым", style: .default) { [unowned self] _ in
            if !self.isSortNewToOld {
                self.isSortNewToOld = true
                try! self.realm.write { self.list.source.reverse() }
            }
            tableView.reloadData()
        }
    }
    
    private func makeOldToNewAction(for tableView: UITableView) -> UIAlertAction {
        return UIAlertAction(title: "От старых к новым", style: .default) { [unowned self] _ in
            if self.isSortNewToOld {
                self.isSortNewToOld = false
                try! self.realm.write { self.list.source.reverse() }
            }
            tableView.reloadData()
        }
    }
    
    private func makeCancelAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}

extension NotesListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        } else {
            return list.source.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let shortNote: ShortNote
        if isFiltering {
            shortNote = ShortNote(from: filteredNotes[indexPath.row])
        } else {
            shortNote = ShortNote(from: list.source[indexPath.row])
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNote.reuseIdentifier) as! CellNote
        cell.shortTextLabel.numberOfLines = 3
        
        cell.shortTextLabel.text = shortNote.text
        cell.dateLabel.text = shortNote.date + ", " + shortNote.time
        
        return cell
    }
}

extension NotesListViewController {
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension NotesListViewController: UISearchResultsUpdating {
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredNotes = list.source.filter { note -> Bool in
            return note.text.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        tableView.reloadData()
    }
}

extension NotesListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = makeDeleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func makeDeleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, completion in
            if self.isFiltering {
                let reference = self.filteredNotes.remove(at: indexPath.row)
                self.deleteNote(from: self.list.source, forReference: reference)
            } else {
                try! self.realm.write {
                    self.list.source.remove(at: indexPath.row)
                }
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        
        return action
    }
    
    private func deleteNote(from source: List<Note>, forReference reference: Note) {
        for i in 0..<source.count {
            let note = source[i]
            if note.isSameObject(as: reference) {
                try! self.realm.write {  source.remove(at: i) }
                break
            }
        }
    }
}
