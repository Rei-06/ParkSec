//
//  reportsimgvc.swift
//  ParkSec
//
//  Created by Nassir Dajer on 12/8/19.
//  Copyright © 2019 FIU. All rights reserved.
//

import UIKit

class reportsimagevc: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0...imgs.count-1 {
            img1[i].image = imgs[i]
            img1[i].transform = CGAffineTransform(rotationAngle: .pi/2) //make images go portrait
        }
    }
    var imgs: [UIImage] = []
    @IBOutlet var img1: [UIImageView]!
}
