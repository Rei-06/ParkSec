//
//  ReportsListDetailViewController.swift
//  ParkingReporter
//
//  Created by Reiner Gonzalez on 12/5/19.
//  Copyright © 2019 Reiner Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class ReportsListDetailViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var plateTextField: UITextField!
    @IBOutlet weak var editLabel: UIBarButtonItem!
    @IBOutlet var carPhotos: [UIImageView]!
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reports = PersistenceManager.sharedInstance
    var report : Reports?
    var isUserEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableEditing()
        for img in carPhotos {
            img.layer.borderWidth = 1
            img.layer.borderColor = UIColor.cyan.cgColor
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        if let testReport = report {
            print(#function)
            plateTextField.text = testReport.plate
            colorTextField.text = testReport.color
            modelTextField.text = testReport.model
            makeTextField.text = testReport.make
            if let photo1 = testReport.photo1?.description {
                let data = UserDefaults.standard.object(forKey: photo1) as! NSData
                carPhotos[0].image = (UIImage(data: data as Data)!)
                carPhotos[0].transform = CGAffineTransform(rotationAngle: .pi/2) //make images go portrait
            }
            
            if let photo2 = testReport.photo2?.description {
                let data = UserDefaults.standard.object(forKey: photo2) as! NSData
                carPhotos[1].image = (UIImage(data: data as Data)!)
                carPhotos[1].transform = CGAffineTransform(rotationAngle: .pi/2)
            }
            
            if let photo3 = testReport.photo3?.description {
                let data = UserDefaults.standard.object(forKey: photo3) as! NSData
                carPhotos[2].image = (UIImage(data: data as Data)!)
                carPhotos[2].transform = CGAffineTransform(rotationAngle: .pi/2)
            }
        }
    }
    
    //action allowing user to enter and save a field into core data
    @IBAction func editTapped(_ sender: Any) {
        
        if !isUserEditing{
            self.navigationItem.rightBarButtonItem?.title = "Save"
            enableEditing()
            isUserEditing = true
        }
        
        else if isUserEditing{
            updateReport()
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            disableEditing()
            isUserEditing = false
        }
    }
    
    //disables editing of each text field in the view
    func disableEditing(){
        plateTextField.isUserInteractionEnabled = false
        colorTextField.isUserInteractionEnabled = false
        modelTextField.isUserInteractionEnabled = false
        makeTextField.isUserInteractionEnabled = false
    }
    
    //enables editing of each text field in the view
    func enableEditing(){
        plateTextField.isUserInteractionEnabled = true
        colorTextField.isUserInteractionEnabled = true
        modelTextField.isUserInteractionEnabled = true
        makeTextField.isUserInteractionEnabled = true
    }
    
    //function takes in input entered by user and uses it to update object created using core data
    func updateReport(){
        report?.plate = plateTextField.text
        report?.color = colorTextField.text
        report?.model = modelTextField.text
        report?.make = makeTextField.text
        reports.saveContext()
    }
    
    
    
    //Textfield first responder functionality 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //dismiss keyboard when tapping outside of it
    @IBAction func tapped(_ sender: UIGestureRecognizer){
        if makeTextField.isEditing {
            textFieldDidEndEditing(makeTextField)
        }
        else if modelTextField.isEditing {
            textFieldDidEndEditing(modelTextField)
        }
        else if colorTextField.isEditing {
            textFieldDidEndEditing(colorTextField)
        }
        else if plateTextField.isEditing {
            textFieldDidEndEditing(plateTextField)
        }
    }
}
