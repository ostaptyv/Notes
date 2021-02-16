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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let navigationVC = window?.rootViewController as! UINavigationController
        let notesListVC = navigationVC.viewControllers.first! as! NotesListViewController
        
        if !notesListVC.isSortNewToOld {
            database.reverseNotesCollection()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

