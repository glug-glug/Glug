//
//  Cell.swift
//  Glug
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isCompleteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
