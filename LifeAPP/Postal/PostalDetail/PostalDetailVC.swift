//
//  PostalDetailVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/24.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class PostalDetailVC: UIViewController {

    @IBOutlet var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.frame.size.width = 361 * screenScaleWidth
        gradientLayer.frame.size.height = 160 * screenSceleHeight
        gradientLayer.colors = [UIColor.set(red: 61, green: 60, blue: 151).cgColor, UIColor.set(red: 52, green: 229, blue: 154).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 8 * screenScaleWidth
        
        gradientView.layer.addSublayer(gradientLayer)
    }

    @IBAction func onDismissClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
