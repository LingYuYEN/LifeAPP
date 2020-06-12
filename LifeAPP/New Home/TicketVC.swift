//
//  TicketVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class TicketVC: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                              NSAttributedString.Key.kern: 1,
                                                              NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 21)!]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "快手振興"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "naviBackIcon"), style: .plain, target: self, action: #selector(onPopClick))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @objc func onPopClick() {
        self.navigationController?.popViewController(animated: true)
    }

}
