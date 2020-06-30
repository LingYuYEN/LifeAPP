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

    @IBOutlet var naviBar: UINavigationBar!
    @IBOutlet var webView: WKWebView!
    var urlStr: String?
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                              NSAttributedString.Key.kern: 1,
                                                              NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 21)!]
        naviBar.titleTextAttributes = textAttributes
        
        let image = UIImage()
        
        naviBar.setBackgroundImage(image, for: .default)
        naviBar.shadowImage = image
        
        // 取消預設 back icon
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlStr = urlStr {
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        
    }


    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
