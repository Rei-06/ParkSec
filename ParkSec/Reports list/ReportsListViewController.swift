//
//  ReportsListtViewController.swift
//  ParkingReporter
//
//  Created by Reiner Gonzalez on 11/26/19.
//  Copyright © 2019 Reiner Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class ReportsListViewController: UIViewController, UISearchBarDelegate {
    
    let reports = PersistenceManager.sharedInstance
    
    @IBOutlet weak var reportListTableView: UITableView!
    @IBOutlet weak var allReportsLabel: UIButton!
    @IBOutlet weak var myReportsLabel: UIButton!
    
    let reportCell = "ReportsListCell"
    
    var results : [Reports] = [] //using this to get test data

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportListTableView.reloadData() //Used so that there is initial data loaded every time this view appears
        styleViews()
        styleButton(button: allReportsLabel)
        styleButton(button: myReportsLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllReports()
        reportListTableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let reportsListDetailViewController = segue.destination as? ReportsListDetailViewController
        
        switch(segue.identifier ?? " ") {
        case "Show report detail":
            let selectedCell = sender as? UITableViewCell
            let indexPath = reportListTableView.indexPath(for: selectedCell!)
            
            let selectedItem = results[(indexPath?.row)!]
            reportsListDetailViewController?.report = selectedItem
            
        default:
            print("error during segue")
        }
        
    }
    
    //Action function for view all reports button
    @IBAction func allReportsTapped(_ sender: Any) {
        getAllReports()
        reportListTableView.reloadData()
    }
    
    
    //Action function for view my reports button
    @IBAction func myReportsTapped(_ sender: Any) {
        getUserReports()
        reportListTableView.reloadData()
    }
    
    
    //format for date being saved by report
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    
    //Search Bar functionalities
    @IBOutlet var searchReports: UISearchBar!
    
    //Search when typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            getFilteredReports(plate: searchText) //create method for this that uses a predicate that searches by plate
        }
        else {
            getAllReports()
        }
        
        reportListTableView.reloadData()
    }
    
    //dismiss keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchReports.text = ""
        self.searchBar(searchReports, textDidChange: searchReports.text!)
        searchReports.endEditing(true)
    }
}


extension ReportsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell info loads specific reports from core data into a variable to populate row in tableview
        let cellInfo = results[indexPath.row]
        let cell = reportListTableView.dequeueReusableCell(withIdentifier: reportCell, for: indexPath) as! ReportsListTableViewCell
        
        //Used native Text - Detail TableCell labels for easier constraint management.
        cell.textLabel!.text = cellInfo.make! + " " + cellInfo.model!
        cell.detailTextLabel!.text = formatter.string(for: cellInfo.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteReport(report: results[indexPath.row])
            results.remove(at: indexPath.row)
            reportListTableView.beginUpdates()
            reportListTableView.deleteRows(at: [indexPath], with: .automatic)
            reportListTableView.endUpdates()
        }
    }
    
    
    //gets ALL reports
    func getAllReports(){
        let context = reports.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reports")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        do {
            
            results = try context.fetch(Reports.fetchRequest())
        }
        catch{
            print("Error fetching data")
        }
    }
    
    //loadReports functions loads data from core data into the results array
    func loadReports(){
        let context = reports.persistentContainer.viewContext
        do {
            results = try context.fetch(Reports.fetchRequest()) as! [Reports]
            print("reports loaded")
        }
        catch{
            print("Error fetching data")
        }
    }
    
    //gets reporsts from a specific user
    func getUserReports(){
        let context = reports.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reports")
        
        //predicate used to look for the employee with the name of the user checking out
        let predicate = NSPredicate(format: "employeeid = %@", argumentArray: [userId])
        
        fetch.predicate = predicate
        do {
            results = try context.fetch(fetch) as! [Reports]
        } catch {
            print("Failed")
        }
    }
    
    //deletes report using specific tag
    func deleteReport(report: Reports){
        let context = reports.persistentContainer.viewContext
            context.delete(report)
            reports.saveContext()
    }
    
    //function styles both the table view rows and the navigation controller tab
    func styleViews(){
        self.navigationItem.title = "Your Reports"
        self.reportListTableView.rowHeight = 65.0
        self.reportListTableView.separatorColor = .black
        self.navigationController?.isNavigationBarHidden = true
        self.reportListTableView.tableFooterView = UIView()
        self.reportListTableView.separatorInset = .zero
        self.reportListTableView.layoutMargins = .zero
        
    }
    
    func styleButton(button: UIButton){
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 10.0
    }
    
    
    //'search by plate' function
    func getFilteredReports(plate: String) {
        let context = reports.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reports")
        
        //predicate used to look for the employee with the name of the user checking out
        let predicate = NSPredicate(format: "plate CONTAINS[c] %@", argumentArray: [plate])
        
        fetch.predicate = predicate
        do {
            results = try context.fetch(fetch) as! [Reports]
        } catch {
            print("Failed")
        }
    }
}








