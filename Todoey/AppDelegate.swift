//
//  AppDelegate.swift
//  Todoey
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
 
import UIKit
import CoreData
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISearchBarDelegate {
 
    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
 
 
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
 
    }
 
    
    // MARK: - Core Data stack
    
    //CORE DATA STEP 1
    lazy var persistentContainer: NSPersistentContainer = {
 
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
 
    // MARK: - Core Data Saving support
    //CRUD: UPDATE
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
 
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
 
}
