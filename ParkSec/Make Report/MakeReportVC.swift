//
//  MakeReportVC.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/3/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit

class MakeReportVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        for img in imgCars {
            img.layer.borderWidth = 3
            img.layer.borderColor = UIColor.cyan.cgColor
            let tap = UITapGestureRecognizer(target: self, action: #selector(takePicture)) //creating a tap gesture that references a function
            img.addGestureRecognizer(tap) //allow taking pictures by tapping the UIImageView
        }
    }
    
    @IBOutlet var btnMakeReport: UIButton!
    override func viewDidLayoutSubviews() {
        btnMakeReport.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet var txtMake: UITextField!
    @IBOutlet var txtModel: UITextField!
    @IBOutlet var txtColor: UITextField!
    @IBOutlet var txtPlate: UITextField!
    
    @IBOutlet var imgCars: [UIImageView]!
    
    @IBAction func makeReport(_ sender: UIButton) {
        var has6Char = true
        var isNotEmpty = true
        
        //validation
        isNotEmpty = txtMake.text!.count < 1 ? false : isNotEmpty
        isNotEmpty = txtModel.text!.count < 1 ? false : isNotEmpty
        isNotEmpty = txtColor.text!.count < 1 ? false : isNotEmpty
        has6Char = txtPlate.text!.count != 6 ? false : has6Char
        let canSubmit = isNotEmpty && has6Char ? true : false //if no fields are empty and Plate has 6 characters, form is valid
        
        if canSubmit {
            performSegue(withIdentifier: "confirm", sender: self)
        }
        
        else if !isNotEmpty { //if any field is empty
            let alert = UIAlertController(title: "Error", message: "One or more fields are empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        else { // if plate is not 6 characters long
            let alert = UIAlertController(title: "Error", message: "Plate must be 6 characters long.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func clearAll() {
        txtMake.text = ""
        txtColor.text = ""
        txtModel.text = ""
        txtPlate.text = ""
        imgCars[0].image = nil
        imgCars[1].image = nil
        imgCars[2].image = nil
    }
    
    
    //camera functionality
    var tappedImageView: UIImageView!
    @objc func takePicture(gRec: UIGestureRecognizer) { //method that handles picture taking
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        tappedImageView = gRec.view as! UIImageView
        present(imagePicker, animated: true, completion: nil)
    }
    
    //set picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        tappedImageView.image = image
        
        dismiss(animated: true, completion: nil)
        
    }
    //end of camera functionality
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //transition to confirm details
        let confRep = segue.destination as! ConfirmReportVC
        
        confRep.color = txtColor.text!
        confRep.plate = txtPlate.text!
        confRep.make = txtMake.text!
        confRep.model = txtModel.text!
        
        for i in 0...imgCars.count-1 {
            if let img = imgCars[i].image {
                confRep.imgs.append(img)
            }
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
        if txtMake.isEditing {
            textFieldDidEndEditing(txtMake)
        }
        else if txtModel.isEditing {
            textFieldDidEndEditing(txtModel)
        }
        else if txtColor.isEditing {
            textFieldDidEndEditing(txtColor)
        }
        else if txtPlate.isEditing {
            textFieldDidEndEditing(txtPlate)
        }
    }
}
