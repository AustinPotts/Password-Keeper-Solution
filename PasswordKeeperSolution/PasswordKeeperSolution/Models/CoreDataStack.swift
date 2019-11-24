//
//  CoreDataStack.swift
//  PasswordKeeperSolution
//
//  Created by Austin Potts on 11/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData




//Create class for Core Data Stack
class CoreDataStack {
    
    
    //Create share instance of CoreDataStack
    static let share = CoreDataStack()
    
    private init() {
        
    }
    
    //Create Container
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Password")
        
     //Load Persistent Stores
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        return container
    }() // Creating only one instance for use
    
    
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.share.mainContext) {
        context.performAndWait {
         
        
        do{
            try mainContext.save()
        } catch {
            NSLog("Error saving context \(error)")
            mainContext.reset()
        }
      }
    }
    
    
}
