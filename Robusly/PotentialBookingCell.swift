//
//  PotentialBookingCell.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/4/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit

class PotentialBookingCell: UITableViewCell {

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientBookingTime: UILabel!
    @IBOutlet weak var clientBookingDate: UILabel!
    @IBOutlet weak var clientBookingLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
