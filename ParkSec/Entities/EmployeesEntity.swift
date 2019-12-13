//
//  Employees.swift
//  ParkSec
//
//  Created by Nassir Dajer on 11/24/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import CoreData

class EmployeesEntity: NSObject, NSFetchedResultsControllerDelegate {
    var _fetchedResultsController: NSFetchedResultsController<Employees>? = nil
    let persistenceManager = PersistenceManager.sharedInstance
    static let sharedInstance = EmployeesEntity()
    
    func getEmployees() -> NSFetchedResultsController<Employees>{

        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Employees> = Employees.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false) //CHANGE ID TO SOMETHING UNIQUE
        
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistenceManager.context, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    
    func getEmployee(_ id: String) -> Employees? { //specific employee
        
        let fetchRequest: NSFetchRequest<Employees> = Employees.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        fetchRequest.predicate = predicate
        
        
        do {
            return try persistenceManager.context.fetch(fetchRequest).first //either will return a value or nil
        } catch {
            return nil //formality try catch for fetch to work
        }
    }
    
    func save() {
        persistenceManager.saveContext()
    }
}
