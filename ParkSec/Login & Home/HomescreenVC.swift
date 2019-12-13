//
//  HomescreenVC.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/8/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit

class HomescreenVC: UIViewController {
    @IBOutlet var btnLogout: UIButton!
    
    override func viewDidLoad() {
        lblWelcome.text = welcome
        lblWelcome.sizeToFit()
    }
    
    override func viewDidLayoutSubviews() {
        btnLogout.layer.cornerRadius = 5
    }
    
    var welcome: String!
    @IBOutlet var lblWelcome: UILabel!
}
