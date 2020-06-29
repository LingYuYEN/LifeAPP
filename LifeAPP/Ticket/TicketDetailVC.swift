//
//  TicketDetailVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/29.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import WebKit

class TicketDetailVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://www.conquers.co/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }


    

}
