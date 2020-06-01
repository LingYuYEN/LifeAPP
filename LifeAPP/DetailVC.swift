//
//  DetailVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/1.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet var gradientView: UIView! {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = [UIColor.set(red: 4, green: 190, blue: 254).cgColor, UIColor.set(red: 68, green: 129, blue: 235).cgColor]
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientView.layer.cornerRadius = 8
            gradientView.clipsToBounds = true
            gradientView.layer.addSublayer(gradientLayer)
        }
    }
    
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var momoLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var publishTimeLabel: UILabel!
    
    var rowCount: Int?
    
    var titleValue: String?
    var value: String?
    var statusValue: String?
    var memoValue: String?
    var cellLabelIsHidden = false
    
//    var pm25: Double?
//    var pm10: Double?
//    var o3: Double?
    var cellLabelStatus = [String]()
    
    var publishTimeValue: String?
    let rowHight = 58
    
    var memoTextArr = [NSMutableAttributedString]()
    var popMemoTextArr = ["1 小時雨量      0 毫米", "24 小時雨量    12 毫米"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CardDetailTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CardDetailTableViewCell")
        
        setUI()
    }

    func setUI() {
        
//        guard let publishTimeValue = publishTimeValue else { return }
//        let dateStr = string2Date(publishTimeValue, dateFormat: "yyyy-MM-dd HH:mm")
//        print(dateStr)
        
        
        self.tableViewHeightConstraint.constant = CGFloat(rowHight * (cellLabelStatus.count))
        
        titleLabel.text = titleValue
        valueLabel.text = value
        momoLabel.text = memoValue
        
        guard let statusValue = statusValue else { return }
        statusImageView.image = UIImage(named: statusValue)
        publishTimeLabel.text = publishTimeValue
        
        tableView.reloadData()
    }
    
    //字符串 -> 日期
    func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }

    @IBAction func onDismissClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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

extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoTextArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardDetailTableViewCell") as! CardDetailTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.attributedText = memoTextArr[indexPath.row]
        cell.memoLabel.text = cellLabelStatus[indexPath.row]
        if cellLabelIsHidden {
            cell.gradientView.isHidden = true
            cell.buttonContentView.layer.borderWidth = 0
            cell.buttonContentView.layer.applySketchShadow(color: .clear, alpha: 0, x: 0, y: 0, blur: 0, spread: 0)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHight)
    }
    
    
}

extension DetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == memoTextArr.count - 1 {
            cell.separatorInset =  UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        }
    }
}
