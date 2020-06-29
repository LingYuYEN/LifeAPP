//
//  PostalCollectionViewCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/22.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class PostalCollectionViewCell: UICollectionViewCell {

    @IBOutlet var gradientBarderView: UIView!
    @IBOutlet var cellContentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    func setUI() {
        gradientBarderView.setGradientBorder(
            lineWidth: 1,
            colors: [
                UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98),
                UIColor.set(red: 6, green: 168, blue: 255)
            ],
            bounds: CGRect(x: 0, y: 0, width: 364 * screenScaleWidth , height: 53 * screenSceleHeight)
        )
        
        self.layoutIfNeeded()
    }
}
