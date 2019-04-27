//
//  PersonalBestTableViewCell.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 27/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

class PersonalBestTableViewCell: UITableViewCell {

    @IBOutlet weak var personalBestImage: UIImageView!
    @IBOutlet weak var personalBestDescLabel: UILabel!
    @IBOutlet weak var personalBestValueLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
