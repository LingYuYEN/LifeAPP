//
//  NewHomeVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class NewHomeVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

}
