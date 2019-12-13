//
//  ScannerVC.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/8/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit

class ScannerVC: UIViewController {
    var codeString: String = "" //String used to pass back to SearchCarVC's search bar after scanning a barcode.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: previewView) //Barcode Scanner API by Mikebuss on GitHub
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            for code in codes {
                                self.codeString = code.stringValue!
                                self.scanner?.stopScanning()
                                break
                            }
                            //Code below is used to pass the scanned barcode to the search bar
                            let destination = self.navigationController?.viewControllers[0] as! CarSearchVC
                            destination.searchBP.text = self.codeString //type into search bar
                            destination.searchBar(destination.searchBP, textDidChange: destination.searchBP.text!) //force search update
                            destination.backFromScanner = true
                            self.navigationController?.popViewController(animated: true) //kill current view to go back to SearchCarVC
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                UIAlertView(title: "Scanning Unavailable", message: "This app does not have permission to access the camera", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
                self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        codeString = ""
        super.viewWillDisappear(animated)
    }
    
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
}
