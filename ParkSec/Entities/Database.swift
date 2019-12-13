////
////  Database.swift
////  ParkSec
////
////  Created by Nassir Dajer on 11/22/19.
////  Copyright © 2019 FIU. All rights reserved.
////
//
import CoreData

final class Database: NSObject, NSFetchedResultsControllerDelegate {
    static let sharedInstance = Database()
    let persistenceManager = PersistenceManager.sharedInstance

    func fetchData<T: NSManagedObject>(type: T.Type) -> [T] { //used to initialize database for the first time only.
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchedObjects = try persistenceManager.context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]() // ?? = else, return empty array of type T
        } catch {
            print("Error while fetching")
            return [T]()
        }
    }

    func confirmLogin(id: String, pass: String) -> Bool {
        for acc in fetchData(type: Accounts.self) {
            if acc.id == id && acc.password == pass {
                return true
            }
        }
        return false
    }

    func fetchResults<T: NSManagedObject>(type: T.Type) -> NSFetchedResultsController<NSManagedObject>{
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let entityName = String(describing: type)

        if entityName == "RegisteredVehicles" {
            let fetchRequest: NSFetchRequest<RegisteredVehicles> = RegisteredVehicles.fetchRequest()

            // Set the batch size to a suitable number.
            fetchRequest.fetchBatchSize = 20

            // Edit the sort key as appropriate.
            let sortDescriptor = NSSortDescriptor(key: "barcode", ascending: false)

            fetchRequest.sortDescriptors = [sortDescriptor]

            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistenceManager.context, sectionNameKeyPath: nil, cacheName: nil)
            aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController as! NSFetchedResultsController<NSManagedObject>

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
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>? = nil

    func initializeDB() { //DO NOT RUN, TABLES ALREADY INITIALIZED
        if let path = Bundle.main.path(forResource: "db", ofType: "plist"),
            let plistDict = NSDictionary(contentsOfFile: path) {
            for val in plistDict {
                if val.key as! String == "Accounts" {
                    // initialize accounts table
                    if !fetchData(type: Accounts.self).isEmpty {continue} //if not empty, do not re-initialize

                    let arrVal = val.value as! NSArray

                    for values in arrVal {
                        let acc = Accounts(context: persistenceManager.context)
                        let data = values as! NSDictionary
                        acc.id = data["id"] as! String
                        acc.password = data["password"] as! String
                        persistenceManager.saveContext()
                    }

                }
                    
                else if val.key as! String == "Employees" {
                    // initialize employees table
                    if !fetchData(type: Employees.self).isEmpty {continue} //if not empty, do not re-initialize

                    let arrVal = val.value as! NSArray

                    for values in arrVal {
                        let emp = Employees(context: persistenceManager.context)
                        let data = values as! NSDictionary
                        emp.id = data["id"] as! String
                        emp.firstname = data["firstname"] as! String
                        emp.lastname = data["lastname"] as! String
                        emp.isNew = (data["isnew"] as! CFBoolean) as! Bool
                        persistenceManager.saveContext()
                    }
                }
                
                else if val.key as! String == "RegisteredVehicles" {
                    // initialize RegisteredVehicles table
                    if !fetchData(type: RegisteredVehicles.self).isEmpty {continue} //if not empty, do not re-initialize

                    let arrVal = val.value as! NSArray

                    for values in arrVal {
                        let regVehicles = RegisteredVehicles(context: persistenceManager.context)
                        let data = values as! NSDictionary
                        regVehicles.assignedspot = data["assignedspot"] as! String
                        regVehicles.barcode = data["barcode"] as! String
                        regVehicles.color = data["color"] as! String
                        regVehicles.make = data["make"] as! String
                        regVehicles.model = data["model"] as! String
                        regVehicles.plate = data["plate"] as! String
                        regVehicles.owner = data["owner"] as! String
                        persistenceManager.saveContext()
                    }
                }
            }
        }
    }
//
//
//
////    func deleteData() {
////        guard let acc = try! persistenceManager.context.fetch(Accounts.fetchRequest()) as? [Accounts]
////            else {return}
////
////        for i in 0...acc.count-1{
////            print(acc[i])
////            persistenceManager.context.delete(acc[i])
////        }
////        persistenceManager.saveContext()
////    }
//
//}
}
