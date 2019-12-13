//
//  ViewController.swift
//  ParkSec
//
//  Created by Nassir Dajer on 11/19/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit
import CoreData

class CarSearchVC: UITableViewController, UISearchBarDelegate {
    
    let regVehicles = RegisteredVehiclesEntity.sharedInstance
    
    //variable that will hold the entire or the filtered collection of registered vehicles in core data
    var result: NSFetchedResultsController<RegisteredVehicles>!
    
    //variable that prevents viewWillAppear from updating the 'result' variable ONLY IF this view appeared after using the barcode scanner
    var backFromScanner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBP.delegate = self
        searchBP.showsBookmarkButton = true
        searchBP.setImage(UIImage(named: "barcode"), for: .bookmark, state: .normal) //create an image "button"
        
        result = regVehicles.getRegisteredVehicles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ Animated: Bool) {
        super.viewWillAppear(Animated)
        if !backFromScanner {
            result = regVehicles.getRegisteredVehicles()
        }
        backFromScanner = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barcode", for: indexPath)
        let regVehicle = result.object(at: indexPath)
        configureCell(cell, withEvent: regVehicle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = result.sections![section]
        return sectionInfo.numberOfObjects
    }
        
    func configureCell(_ cell: UITableViewCell, withEvent vehicle: RegisteredVehicles) {
        cell.textLabel!.text = vehicle.barcode!.description
        cell.detailTextLabel!.text = vehicle.plate!.description
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "scanner" { //Nothing actions needed in case it were == "scanner"
            let destination = segue.destination as! RegisteredVehicleVC
            
            let selectedCell = sender as! UITableViewCell
            let index = tableView.indexPath(for: selectedCell)
            let carInfo = result.object(at: index!)
            
            //initialize variables to then initialize textfields for the incoming Car Info view
            destination.make = carInfo.make
            destination.model = carInfo.model
            destination.color = carInfo.color
            destination.owner = carInfo.owner
            destination.plate = carInfo.plate
            destination.spot = carInfo.assignedspot
            destination.barcode = carInfo.barcode
        }
    }
    
    
    @IBOutlet weak var searchBP: UISearchBar! //BP = barcode/plate
    
    //start searching for records when text is entered
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            result = regVehicles.getFilteredVehicle(searchText)
            print(result.fetchedObjects!.first)
        }
        else {
            result = regVehicles.getRegisteredVehicles()
        }
        
        tableView.reloadData()
    }
    
    //grant image "button" a functionality... segue to barcode scanner
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "scanner", sender: nil)
    }
    
    //dismiss keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBP.text = ""
        self.searchBar(searchBP, textDidChange: searchBP.text!)
        searchBP.endEditing(true)
    }
}
