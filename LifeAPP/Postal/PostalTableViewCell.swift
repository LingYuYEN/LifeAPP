//
//  PostalTableViewCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/22.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class PostalTableViewCell: UITableViewCell {

    @IBOutlet var zipCodeLabel: UILabel!
    @IBOutlet var roadLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
