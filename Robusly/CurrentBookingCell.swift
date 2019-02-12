//
//  CurrentBookingCell.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/5/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit

class CurrentBookingCell: UITableViewCell {

    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
