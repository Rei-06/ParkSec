//
//  AccountsEntity.swift
//  ParkSec
//
//  Created by Nassir Dajer on 11/23/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import CoreData

class AccountsEntity: NSObject, NSFetchedResultsControllerDelegate {
    var _fetchedResultsController: NSFetchedResultsController<Accounts>? = nil
    let persistenceManager = PersistenceManager.sharedInstance
    static let sharedInstance = AccountsEntity()
    
func getAccounts() -> NSFetchedResultsController<Accounts>{ //gets all the accounts in the database
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
    
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
    
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
    
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    
    
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistenceManager.context, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
    
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    
    func getSingleAccount(id: String, pass: String) -> Accounts?{ //gets a single account from the database, according to a predicate
        
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()

        let predicate = NSPredicate(format: "id =[c] %@ AND password = %@", argumentArray: [id, pass])
        fetchRequest.predicate = predicate
        
        print(id + " " + pass)
        do {
            return try persistenceManager.context.fetch(fetchRequest).first //either will return a value or nil
        } catch {
            return nil //formality try catch for fetch to work
        }
    }
}
