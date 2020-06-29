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
            gradientLayer.colors = [
                UIColor.set(red: 1, green: 69, blue: 189).cgColor,
                UIColor.set(red: 2, green: 5, blue: 113).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
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
    @IBOutlet var dismiaaBtn: UIButton!
    @IBOutlet var cardContentView: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CardDetailTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CardDetailTableViewCell")
        
        setUI()
    }

    func setUI() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDismissAction))
        let btnTap = UITapGestureRecognizer(target: self, action: #selector(btnDismissAction))
        let cardTap = UITapGestureRecognizer(target: self, action: #selector(cardDismissAction))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.dismiaaBtn.addGestureRecognizer(btnTap)
        self.cardContentView.addGestureRecognizer(cardTap)
        
        self.tableViewHeightConstraint.constant = CGFloat(rowHight * (cellLabelStatus.count))
        
        titleLabel.text = titleValue
        valueLabel.text = value
        momoLabel.text = memoValue
        
        guard let statusValue = statusValue else { return }
        statusImageView.image = UIImage(named: statusValue)
        publishTimeLabel.text = publishTimeValue
        
        tableView.reloadData()
    }
    
    @objc func viewDismissAction() {
        self.dismiss(animated: false, completion: nil)
    }
    @objc func btnDismissAction() {
        self.dismiss(animated: false, completion: nil)
    }
    @objc func cardDismissAction() {
        print("no action")
    }
    
    
    //字符串 -> 日期
    func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }

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
