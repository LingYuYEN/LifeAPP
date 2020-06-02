//
//  MenuVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/2.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    let titleNameArr = ["天氣快報", "油價資訊", "振興券專區"]
    let titleImageNameArr = ["wetherIcon1", "oilIcon", "ticketIcon"]
    let rowHeight = 130 * screenSceleHeight
    let presentIdArr = ["oilVC", "oilVC", "oilVC"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.isScrollEnabled = false
    }

}

extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.titleLabel.text = titleNameArr[indexPath.row]
        cell.titleImage.image = UIImage(named: titleImageNameArr[indexPath.row])
        return cell
    }
    
    
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

//        guard let vcArr = self.navigationController?.viewControllers else { return }
//        let vc = OilVC.loadFromNib()
        
        
//        let naviController = UINavigationController(rootViewController: vc)
//        naviController.modalPresentationStyle = .overFullScreen
        
//        self.navigationController?.present(naviController, animated: true, completion: nil)
//        self.navigationController?.popToRootViewController(animated: true)
//        guard let vc = navigationController?.viewControllers[1] else { return }
//        self.navigationController?.popToViewController(vc, animated: true)
        

        let vc = OilVC.loadFromNib()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.show(vc, sender: self)
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
        
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
}
