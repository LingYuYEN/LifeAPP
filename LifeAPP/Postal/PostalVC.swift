//
//  PostalVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/20.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class PostalVC: UIViewController {

    
    @IBOutlet var naviBar: UINavigationBar!
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        naviBar.setBackgroundImage(image, for: .default)
        naviBar.shadowImage = image
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
