//
//  DeniedProjectsCell.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/9/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit

class DeniedProjectsCell: UITableViewCell {

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientBookingTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
