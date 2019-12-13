//
//  RegisteredVehicleVC.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/7/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit

class RegisteredVehicleVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) { //initializes all textfields with values obtained during segue
        super.viewWillAppear(animated)
        txtMake.text = make
        txtModel.text = model
        txtColor.text = color
        txtPlate.text = plate
        txtBarcode.text = barcode
        txtOwner.text = owner
        txtSpot.text = spot
    }
    
    var make: String!, model: String!, color: String!,
    plate: String!, barcode: String!, owner: String!,
    spot: String!
    
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtPlate: UITextField!
    @IBOutlet weak var txtBarcode: UITextField!
    @IBOutlet weak var txtOwner: UITextField!
    @IBOutlet weak var txtSpot: UITextField!
    
    
}
