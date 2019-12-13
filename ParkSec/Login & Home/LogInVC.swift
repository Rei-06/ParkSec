//
//  LogInVC.swift
//  ParkSec
//
//  Created by Nassir Dajer on 11/19/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit
import CoreData

var userId: String! //the logged in user's ID
var userName: String! //the logged in user's Name

class LogInViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var txtId: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var btnLogin: UIButton!
    
    var managedObjectContext: NSManagedObjectContext? = nil
    let account = AccountsEntity.sharedInstance
    var emp: Employees!
    let employee = EmployeesEntity.sharedInstance
    let db = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db.initializeDB() //used to initialize core data database. method will initialize the specified entities ONLY if they are empty.
        txtId.layer.borderColor = UIColor.gray.cgColor
        txtId.layer.borderWidth = 1
        txtPass.layer.borderColor = UIColor.gray.cgColor
        txtPass.layer.borderWidth = 1
    }
    
    override func viewDidLayoutSubviews() {
        let screen = self.view.frame.width
        let stack = self.view.subviews[0]
        let widthConst = NSLayoutConstraint(item: stack, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: screen/1.9)
        stack.addConstraint(widthConst)
        btnLogin.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) { //working
        if let id = txtId.text?.trimmingCharacters(in: .whitespacesAndNewlines), let pass = txtPass.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if let accItems = account.getSingleAccount(id: id, pass: pass) { //if not nil, account exists
                userId = id
                emp = employee.getEmployee(id)
                userName = (emp?.firstname)! + " " + (emp?.lastname)!
                performSegue(withIdentifier: "login", sender: nil)
            }
            else { //no records
                let alert = UIAlertController(title: "Incorrect Credentials", message: "Wrong Username or Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabbar = segue.destination as! UITabBarController
        
        let destination = tabbar.viewControllers![0] as! HomescreenVC
        if emp.isNew {
            destination.welcome = "Welcome to Park Security, " + emp.firstname! + " " + emp.lastname! + "."
            emp.isNew = false
            employee.save()
        }
            
        else {
            destination.welcome = "Welcome back, " + emp.firstname! + "!"
        }
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
        if txtId.isEditing {
            textFieldDidEndEditing(txtId)
        }
        else if txtPass.isEditing {
            textFieldDidEndEditing(txtPass)
        }
    }
}
