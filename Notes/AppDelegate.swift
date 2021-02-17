//
//  AppDelegate.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var database: Database<Note> {
        return DatabaseRealm.shared
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = NotesListViewController.instance()
        self.window?.rootViewController = rootViewController
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let navigationVC = window?.rootViewController as! UINavigationController
        let notesListVC = navigationVC.viewControllers.first! as! NotesListViewController
        
        if !notesListVC.isSortNewToOld {
            database.reverseNotesCollection()
        }
        /*
         Since initial value of isSortNewToOld property in NotesListViewController is true, we should take care about to return the state of the system to appropriate this value (basically here and further we will working out case when isSortNewToOld can be "false" because when isSortNewToOld is "true" nothing bad happens).
         In case if sort was changed to "old to new" and reversedCollection() was called, here we call reversedCollection(), in fact making it "new to old", but not changing value of isSortNewToOld (isSortNewToOld sill will be "false").
        And there're 2 ways:
         1) if app will be closed, then value of isSortNewToOld will be reseted and initialized with true next time app will launch, and order in list.source will correlate with isSortNewToOld.
         Otherway, 2) if app will continue its work and won't be closed, we call reverseCollection() in applicationWillEnterForeground(_:) method to return it to state "old to new"
         */
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let navigationVC = window?.rootViewController as! UINavigationController
        let notesListVC = navigationVC.viewControllers.first! as! NotesListViewController
        
        if !notesListVC.isSortNewToOld {
            database.reverseNotesCollection()
        }
    }

}

