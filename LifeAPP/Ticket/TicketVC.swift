//
//  TicketVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class TicketVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    
    let cellNames = ["介紹、領取、使用懶人包", "信用卡優惠懶人包", "商家加值懶人包"]
        
    override func viewDidAppear(_ animated: Bool) {
        let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                              NSAttributedString.Key.kern: 1,
                                                              NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 21)!]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "快手振興"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TicketCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TicketCollectionViewCell")
    }

}

extension TicketVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCollectionViewCell", for: indexPath) as! TicketCollectionViewCell
        cell.titleLabel.text = cellNames[indexPath.row]
        
        return cell
    }
    
    
}
extension TicketVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(cellNames[indexPath.row])
        
    }
}
extension TicketVC: UICollectionViewDelegateFlowLayout {
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 25 * screenScaleWidth, bottom: 40, right: 25 * screenScaleWidth)
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 364 * screenScaleWidth , height: 100)
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
