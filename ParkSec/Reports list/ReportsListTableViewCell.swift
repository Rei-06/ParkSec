//
//  ReportsListTableViewCell.swift
//  ParkingReporter
//
//  Created by Reiner Gonzalez on 11/26/19.
//  Copyright © 2019 Reiner Gonzalez. All rights reserved.
//

import UIKit

class ReportsListTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

