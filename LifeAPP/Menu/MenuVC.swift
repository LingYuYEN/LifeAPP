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
    
//    let titleNameArr = ["天氣快報", "油價資訊", "振興券專區"]
//    let titleImageNameArr = ["wetherIcon1", "oilIcon", "ticketIcon"]
    let titleNameArr = ["天氣快報", "油價資訊"]
    let titleImageNameArr = ["wetherIcon", "oilIcon"]
    let rowHeight = 130 * screenSceleHeight
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isHidden = false
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
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        switch indexPath.row {
        case 0:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "main")
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let oilVC = OilVC.loadFromNib()
            oilVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(oilVC, animated: true)
        default:
            break
        }
    }
    
    
}
