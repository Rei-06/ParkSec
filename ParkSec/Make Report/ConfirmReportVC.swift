//
//  ConfirmReport.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/4/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit

class ConfirmReportVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for img in imgCars {
            img.layer.borderWidth = 3
            img.layer.borderColor = UIColor.cyan.cgColor
        }
        
        if !imgs.isEmpty {
            for i in 0...imgs.count-1 {
                imgCars[i].image = imgs[i]
            }
        }
        
        txtMake.text = make
        txtModel.text = model
        txtPlate.text = plate
        txtColor.text = color
    }
    
    
    @IBOutlet var btnFinish: UIButton!
    override func viewDidLayoutSubviews() {
        btnFinish.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var make: String!, model: String!,
    color: String!, plate: String!,
    imgs: [UIImage] = [] // max of 3 pictures
    
    @IBOutlet var txtMake: UITextField!
    @IBOutlet var txtModel: UITextField!
    @IBOutlet var txtColor: UITextField!
    @IBOutlet var txtPlate: UITextField!
    
    @IBOutlet var imgCars: [UIImageView]!
    
    var reports = ReportsEntity.sharedInstance
    
    @IBAction func submitReport(_ sender: UIButton) {
        let make = txtMake.text!, model = txtModel.text!, color = txtColor.text!, plate = txtPlate.text!
        if reports.saveReport(make: make, model: model, color: color, plate: plate, images: imgs) {
            let alert = UIAlertController(title: "Report Saved", message: "Report was created successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (save) in
                self.navigationController?.popViewController(animated: true)
                let destination = self.navigationController?.viewControllers[0] as! MakeReportVC //go back to previous view
                destination.clearAll() //and clear all fields
            }))
            present(alert, animated: true)
        }
    }
}
