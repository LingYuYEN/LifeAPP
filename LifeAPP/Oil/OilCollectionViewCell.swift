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
    
    func setOilAttr(cnpcStr: String, formosaStr: String, oilLevel: Int, cnpc: UILabel, formosa: UILabel) {
        switch oilLevel {
        case 0:
            let cnpcAttributedString = NSMutableAttributedString(string: cnpcStr)
            cnpcAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSRange(location: 0, length: cnpcAttributedString.length))
            cnpcAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 17)!,
                                          range: NSRange(location: 0, length: 2))
            cnpcAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 23)!,
                                          range: NSRange(location: 4, length: 4))
            
            let formosaAttributedString = NSMutableAttributedString(string: formosaStr)
            formosaAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSRange(location: 0, length: formosaAttributedString.length))
            formosaAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 17)!,
                                          range: NSRange(location: 0, length: 2))
            formosaAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 23)!,
                                          range: NSRange(location: 4, length: 4))
            
            cnpc.attributedText = cnpcAttributedString
            formosa.attributedText = formosaAttributedString
        case 1:
            let cnpcAttributedString = NSMutableAttributedString(string: cnpcStr)
            cnpcAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.setCheapPrice()], range: NSRange(location: 0, length: cnpcAttributedString.length))
            cnpcAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 17)!,
                                          range: NSRange(location: 0, length: 2))
            cnpcAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 23)!,
                                          range: NSRange(location: 4, length: 4))
            
            let formosaAttributedString = NSMutableAttributedString(string: formosaStr)
            formosaAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSRange(location: 0, length: formosaAttributedString.length))
            formosaAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 17)!,
                                          range: NSRange(location: 0, length: 2))
            formosaAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 23)!,
                                          range: NSRange(location: 4, length: 4))
            
            cnpc.attributedText = cnpcAttributedString
            formosa.attributedText = formosaAttributedString
        case 2:
            let cnpcAttributedString = NSMutableAttributedString(string: cnpcStr)
            cnpcAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSRange(location: 0, length: cnpcAttributedString.length))
            cnpcAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 17)!,
                                          range: NSRange(location: 0, length: 2))
            cnpcAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 23)!,
                                          range: NSRange(location: 4, length: 4))
            
            let formosaAttributedString = NSMutableAttributedString(string: formosaStr)
            formosaAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.setCheapPrice()], range: NSRange(location: 0, length: formosaAttributedString.length))
            formosaAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 17)!,
                                          range: NSRange(location: 0, length: 2))
            formosaAttributedString.addAttribute(.font,
                                          value: UIFont(name: "PingFangTC-Regular", size: 23)!,
                                          range: NSRange(location: 4, length: 4))
            
            cnpc.attributedText = cnpcAttributedString
            formosa.attributedText = formosaAttributedString
        default:
            break
        }
    }

}
