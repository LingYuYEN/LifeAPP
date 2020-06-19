//
//  NewHomeVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class NewHomeVC: UIViewController {
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    let iconImageNames = ["newHomeWeatherIcon", "newHomeOilIcon", "newHomeTicketIcon", "newHomeCityIcon", "newHomeQrcodeIcon", "newHomePostalIcon"]
    let cellNames = ["天氣資訊", "油價預測", "三倍券與旅遊振興資訊", "各縣市大型旅遊景點", "發票開獎與掃描對獎", "郵遞區號快速查詢"]
    let vcMap = [0 : "ticket", 1 : "ticket", 2 : "ticket", 3 : "ticket", 4 : "ticket", 5 : "ticket"]
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
        let backImageView = UIImageView()
        backImageView.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        backImageView.image = UIImage(named: "naviBackIcon")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: backImageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "NewHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewHomeCollectionViewCell")
        collectionView.register(UINib(nibName: "NewHomeWeatherCell", bundle: nil), forCellWithReuseIdentifier: "NewHomeWeatherCell")
        collectionView.register(UINib(nibName: "NewHomeOilCell", bundle: nil), forCellWithReuseIdentifier: "NewHomeOilCell")
    }
    
    
}

extension NewHomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomeWeatherCell", for: indexPath) as! NewHomeWeatherCell
            cell.iconImageView.image = UIImage(named: iconImageNames[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomeOilCell", for: indexPath) as! NewHomeOilCell
            cell.iconImageView.image = UIImage(named: iconImageNames[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomeCollectionViewCell", for: indexPath) as! NewHomeCollectionViewCell
            cell.iconImageView.image = UIImage(named: iconImageNames[indexPath.row])
            cell.titleLabel.text = cellNames[indexPath.row]
            return cell
        }
    }
    
    
}
extension NewHomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(cellNames[indexPath.row])
        
        guard let id = vcMap[indexPath.row] else { return }
        if let vc = storyboard?.instantiateViewController(withIdentifier: id) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension NewHomeVC: UICollectionViewDelegateFlowLayout {
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40 * screenSceleHeight, left: 25 * screenScaleWidth, bottom: 40, right: 25 * screenScaleWidth)
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: 364 * screenScaleWidth , height: 119 * screenSceleHeight)
        case 1:
            return CGSize(width: 364 * screenScaleWidth , height: 148 * screenSceleHeight)
        default:
            return CGSize(width: 364 * screenScaleWidth , height: 86 * screenSceleHeight)
        }
        
    }
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(18)
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
