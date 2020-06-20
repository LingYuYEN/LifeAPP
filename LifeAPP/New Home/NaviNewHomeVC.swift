//
//  NaviNewHomeVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit


class NaviNewHomeVC: UINavigationController {

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.backBarButtonItem?.image = UIImage(named: "")
        
    }
    


}
