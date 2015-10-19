//
//  MealTableViewCell.swift
//  MyTreat
//
//  Created by GMSW on 10/14/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var labelResaurantName: UILabel!
    @IBOutlet weak var labelWhoPaid: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
