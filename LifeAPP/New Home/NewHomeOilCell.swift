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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setUI()
    }

    func setUI() {
        
//        effectView.layer.applySketchShadow(color: .set(red: 13, green: 121, blue: 183), alpha: 1, x: 0, y: 0, blur: 5, spread: 0)
//        effectView.layer.applySketchShadow(color: .white, alpha: 1, x: 1, y: 1, blur: 3, spread: 0)
//        effectView.layer.masksToBounds = false
        
        effectView.setGradientBorder(
            lineWidth: 1,
            colors: [
                UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98),
                UIColor.set(red: 6, green: 168, blue: 255)
            ]
        )

        self.layoutIfNeeded()
    }
}


