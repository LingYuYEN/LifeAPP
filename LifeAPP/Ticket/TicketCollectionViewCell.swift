//
//  TicketCollectionViewCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class TicketCollectionViewCell: UICollectionViewCell {

    @IBOutlet var gradientView: UIView!
    @IBOutlet var cellContentView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        
        self.layer.cornerRadius = 8 * screenScaleWidth
        self.layer.applySketchShadow(color: .set(red: 13, green: 121, blue: 183), alpha: 1, x: 0, y: 0, blur: 5, spread: 0)
        self.layer.masksToBounds = false

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98).cgColor, UIColor.set(red: 6, green: 168, blue: 255).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 8 * screenScaleWidth

        gradientView.layer.addSublayer(gradientLayer)

        self.cellContentView.layer.cornerRadius = 8 * screenScaleWidth
        self.cellContentView.layer.masksToBounds = false

        self.imageView.layer.cornerRadius = 8 * screenScaleWidth
        self.imageView.clipsToBounds = true
    }

}
