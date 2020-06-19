//
//  NewHomeCollectionViewCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class NewHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var effectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        setUI()
    }
    
    func setUI() {
        
        //        self.layer.applySketchShadow(color: .set(red: 13, green: 121, blue: 183), alpha: 1, x: 0, y: 0, blur: 5, spread: 0)
        //        self.layer.masksToBounds = false
        
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
