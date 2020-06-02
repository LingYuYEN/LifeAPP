//
//  OilCollectionViewCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/2.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class OilCollectionViewCell: UICollectionViewCell {

    @IBOutlet var gradientView: UIView! {
       didSet {
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = gradientView.bounds
           gradientLayer.colors = [UIColor.set(red: 6, green: 65, blue: 85).cgColor, UIColor.set(red: 18, green: 40, blue: 68).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
           gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
           gradientView.layer.addSublayer(gradientLayer)
       }
    }
    
    @IBOutlet var cellContentView: UIView! {
        didSet {
            cellContentView.layer.borderWidth = 1
            cellContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            cellContentView.layer.cornerRadius = 8
        }
    }
    @IBOutlet var oilNameLabel: UILabel!
    @IBOutlet var cnpcPrice: UILabel!
    @IBOutlet var formosaPrice: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
