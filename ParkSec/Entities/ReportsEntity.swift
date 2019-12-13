//
//  Reports.swift
//  ParkSec
//
//  Created by Nassir Dajer on 11/24/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import CoreData
import UIKit

class ReportsEntity: NSObject, NSFetchedResultsControllerDelegate {
    var _fetchedResultsController: NSFetchedResultsController<Reports>? = nil
    let persistenceManager = PersistenceManager.sharedInstance
    static let sharedInstance = ReportsEntity()
    
    func getReports() -> NSFetchedResultsController<Reports>{

        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Reports> = Reports.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "tag", ascending: false)
        
        
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
    
    func createNewTag() -> Int{
        let fetchRequest: NSFetchRequest<Reports> = Reports.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tag", ascending: false)] // first record is the highest tag, so descending
        
        do {
            let record = try persistenceManager.context.fetch(fetchRequest)
            if record.count != 0 {
                return Int(record.first!.tag) + 1 //latest record + 1 = a new, unique tag number
            }
        } catch {
            return 0
        }
        return 0
    }
    
    func saveReport(make: String, model: String, color: String, plate: String, images: [UIImage]) -> Bool {
        //make tag unique
        let newTag = createNewTag()
        
        let reports = Reports(context: persistenceManager.context)
        
        reports.make = make
        reports.model = model
        reports.color = color
        reports.plate = plate
        reports.tag = Int16(newTag)
        reports.date = Date()
        reports.employeeid = userId
        var imageId: [String] = []
        if !images.isEmpty {
            for i in 0...images.count-1 {
                imageId.append(UUID().uuidString)
                UserDefaults.standard.set(UIImagePNGRepresentation(images[i])!, forKey: imageId[i]) //save picture with unique key
                //print("remember to uncomment saving code in reports entity")
            }

           // now save UUIDs for each picture in core data

            if imageId.count == 3 {
                reports.photo1 = imageId[0]
                reports.photo2 = imageId[1]
                reports.photo3 = imageId[2]
            }
            else if imageId.count == 2 {
                reports.photo1 = imageId[0]
                reports.photo2 = imageId[1]
            }
            else if imageId.count == 1 {
                reports.photo1 = imageId[0]
            }
        }
        
        do {
            try persistenceManager.context.save()
            return true
        } catch {
            return false
        }
        return true
    }
}
