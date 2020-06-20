//
//  CardDetailTableViewCell.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/1.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class CardDetailTableViewCell: UITableViewCell {

    @IBOutlet var gradientView: UIView! {
           didSet {
               let gradientLayer = CAGradientLayer()
               gradientLayer.frame = gradientView.bounds
               gradientLayer.colors = [
                   UIColor.set(red: 1, green: 69, blue: 189).cgColor,
                   UIColor.set(red: 2, green: 5, blue: 113).cgColor
               ]
               gradientLayer.startPoint = CGPoint(x: 1, y: 0)
               gradientLayer.endPoint = CGPoint(x: 0, y: 1)
               gradientView.layer.cornerRadius = 8
               gradientView.clipsToBounds = true
               gradientView.layer.addSublayer(gradientLayer)
           }
       }
    @IBOutlet var buttonContentView: UIView! {
        didSet {
            buttonContentView.layer.cornerRadius = 8
            buttonContentView.layer.applySketchShadow(color: .black, alpha: 0.5, x: 1, y: 1, blur: 2, spread: 0)
            
            buttonContentView.layer.borderWidth = 1
            buttonContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        }
    }
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
