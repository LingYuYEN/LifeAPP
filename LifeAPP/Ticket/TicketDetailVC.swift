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
    var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlStr = urlStr {
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        
    }


    

}
