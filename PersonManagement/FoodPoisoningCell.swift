//
//  FoodPoisoningCell.swift
//  PersonManagement
//
//  Created by 503-26 on 26/11/2018.
//  Copyright © 2018 person. All rights reserved.
//

import UIKit

class FoodPoisoningCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblRisk: UILabel!
    @IBOutlet weak var lblCnt: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
