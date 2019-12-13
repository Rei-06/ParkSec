//
//  reportsvc.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/8/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit
import CoreData

class reportsvc: UITableViewController {
    var result: NSFetchedResultsController<Reports>!
    let reports = ReportsEntity.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ Animated: Bool) {
        super.viewWillAppear(Animated)
        result = reports.getReports()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reports", for: indexPath)
        let report = result.object(at: indexPath)
        configureCell(cell, withEvent: report)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = result.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func configureCell(_ cell: UITableViewCell, withEvent report: Reports) {
        cell.textLabel!.text = report.plate!
        cell.detailTextLabel!.text = DateFormatter.localizedString(from: report.date!, dateStyle: .long, timeStyle: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! reportsimagevc
        let selectedCell = sender as! UITableViewCell
        let selectedIndex = tableView.indexPath(for: selectedCell)
        
        let report = result.object(at: selectedIndex!)
        
        if let photo1 = report.photo1?.description {
            let data = UserDefaults.standard.object(forKey: photo1) as! NSData
            destination.imgs.append(UIImage(data: data as Data)!)
        }
        
        if let photo2 = report.photo2?.description {
            let data = UserDefaults.standard.object(forKey: photo2) as! NSData
            destination.imgs.append(UIImage(data: data as Data)!)
        }
        
        if let photo3 = report.photo3?.description {
            let data = UserDefaults.standard.object(forKey: photo3) as! NSData
            destination.imgs.append(UIImage(data: data as Data)!)
        }
    }
}
