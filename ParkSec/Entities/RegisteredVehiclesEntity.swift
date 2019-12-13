//
//  RegisteredVehiclesEntity.swift
//  ParkSec
//
//  Created by Nassir Dajer on 11/23/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import CoreData

class RegisteredVehiclesEntity: NSObject, NSFetchedResultsControllerDelegate {
    var _fetchedResultsController: NSFetchedResultsController<RegisteredVehicles>? = nil
    let persistenceManager = PersistenceManager.sharedInstance
    static let sharedInstance = RegisteredVehiclesEntity()
    
    func getRegisteredVehicles() -> NSFetchedResultsController<RegisteredVehicles> {
        let fetchRequest: NSFetchRequest<RegisteredVehicles> = RegisteredVehicles.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "barcode", ascending: true)
        
        
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
    
    func getFilteredVehicle(_ bp: String) -> NSFetchedResultsController<RegisteredVehicles> { 
        let fetchRequest: NSFetchRequest<RegisteredVehicles> = RegisteredVehicles.fetchRequest()
        
        let predicate = NSPredicate(format: "barcode CONTAINS %@ OR plate CONTAINS[c] %@", argumentArray: [bp, bp])
        fetchRequest.predicate = predicate
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "barcode", ascending: true)
        
        
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
}
