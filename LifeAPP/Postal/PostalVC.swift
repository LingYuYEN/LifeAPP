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
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBtnContentView: UIView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var searchBtn: UIButton!
    
    let cellDefaultTitleArr = ["選擇縣市", "選擇區域", "選擇區域路名段號"]
    var zipFiveArr = [String]()
    var cityArr = [String]()
    var areaArr = [String]()
    var roadArr = [String]()
    var scopeArr = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        collectionView.register(UINib(nibName: "PostalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostalCollectionViewCell")
        tableView.register(UINib(nibName: "PostalTableViewCell", bundle: nil), forCellReuseIdentifier: "PostalTableViewCell")
        tableView.register(UINib(nibName: "PostalTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "PostalTableViewHeaderView")
        
        
        
        DataManager.shared.getZipFive { (model, error) -> (Void) in
            guard let models = model else { return }
            
            var newZipFiveArr = [String]()
            var newCityArr = [String]()
            var newAreaArr = [String]()
            var newRoadArr = [String]()
            var newScopeArr = [String]()
            
            for model in models {
                newZipFiveArr.append(model.zip5)
                newCityArr.append(model.city)
                newAreaArr.append(model.area)
                newRoadArr.append(model.road)
                newScopeArr.append(model.scope)
            }
            
            self.zipFiveArr = newZipFiveArr
            self.cityArr = newCityArr
            self.areaArr = newAreaArr
            self.roadArr = newRoadArr
            self.scopeArr = newScopeArr
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    
        
        setUI()
    }
    
    
    
    func setUI() {
        gradientView.layer.applySketchShadow(color: .set(red: 13, green: 121, blue: 183), alpha: 1, x: 0, y: 0, blur: 5, spread: 0)
        gradientView.setGradientBorder(
            lineWidth: 1,
            colors: [
                UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98),
                UIColor.set(red: 6, green: 168, blue: 255)
            ]
        )
    }

}

extension PostalVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDefaultTitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostalCollectionViewCell", for: indexPath) as! PostalCollectionViewCell
        
        cell.titleLabel.text = self.cellDefaultTitleArr[indexPath.row]
        return cell
    }
    
    
}

extension PostalVC: UICollectionViewDelegate {
    
}

extension PostalVC: UICollectionViewDelegateFlowLayout {
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20 * screenSceleHeight, left: 25 * screenScaleWidth, bottom: 15 * screenSceleHeight, right: 25 * screenScaleWidth)
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 364 * screenScaleWidth , height: 53 * screenSceleHeight)
    }
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
    
    /// 滑動方向為「垂直」的話即「左右」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 * screenScaleWidth
    }
}

extension PostalVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipFiveArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostalTableViewCell", for: indexPath) as! PostalTableViewCell
        cell.zipCodeLabel.text = self.zipFiveArr[indexPath.row]
        cell.roadLabel.text = "\(self.areaArr[indexPath.row])  \(self.roadArr[indexPath.row])"
        cell.numberLabel.text = self.scopeArr[indexPath.row]
        return cell
    }
    
    
}

extension PostalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36 * screenSceleHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PostalTableViewHeaderView")
        // 取消
        
        return headerView
    }
}
