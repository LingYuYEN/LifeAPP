//
//  NewHomeWeatherCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/19.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class NewHomeWeatherCell: UICollectionViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var cityAndTempLabel: UILabel!
    @IBOutlet var popLabel: UILabel!
    @IBOutlet var maxAndMinTempLabel: UILabel!
    @IBOutlet var uviLabel: UILabel!
    @IBOutlet var leftStackView: UIStackView!
    @IBOutlet var rightStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUI()
    }

    func setUI() {

        leftStackView.spacing = 20 * screenSceleHeight
        rightStackView.spacing = 20 * screenSceleHeight
        
//        self.layer.applySketchShadow(color: .set(red: 13, green: 121, blue: 183), alpha: 1, x: 0, y: 0, blur: 5, spread: 0)
//        self.layer.masksToBounds = false
        
        self.setGradientBorder(
            lineWidth: 1,
            colors: [
                UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98),
                UIColor.set(red: 6, green: 168, blue: 255)
            ]
        )

        self.layoutIfNeeded()
    }
}
