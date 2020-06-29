//
//  NewHomeOilCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/19.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class NewHomeOilCell: UICollectionViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var effectView: UIView!
    
    @IBOutlet var oilTitleLabel: UILabel!
    @IBOutlet var oilUpAndDownImageView: UIImageView!
    @IBOutlet var oilUpAndDownTextLabel: UILabel!
    @IBOutlet var oilChangeLabel: UILabel!
    @IBOutlet var oil92Label: UILabel!
    @IBOutlet var oil98Label: UILabel!
    @IBOutlet var oil95Label: UILabel!
    @IBOutlet var oilDieselLabel: UILabel!
    
    @IBOutlet var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var oil92LabelBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setUI()
    }

    func setUI() {
        
        titleLabelBottomConstraint.constant = 15 * screenSceleHeight
        oil92LabelBottomConstraint.constant = 13 * screenSceleHeight
        
        effectView.setGradientBorder(
            lineWidth: 1,
            colors: [
                UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98),
                UIColor.set(red: 6, green: 168, blue: 255)
            ],
            bounds: CGRect(x: 0, y: 0, width: 364 * screenScaleWidth , height: 148 * screenSceleHeight)
        )

        self.layoutIfNeeded()
    }
}


