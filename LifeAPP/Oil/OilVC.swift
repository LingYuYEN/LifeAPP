//
//  OilVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/2.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OilVC: UIViewController {
    
    let oilNameArr = ["92  無鉛", "95  無鉛", "98  無鉛", "高級柴油"]
    var cnpcPriceArr = ["-", "-", "-", "-"]
    var formosaPriceArr = ["-", "-", "-", "-"]
    let cellHeight = 60 * screenSceleHeight
    var shareMessage = ""
    let levelTextMap = [1 : "漲", 2 : "持\n平", 3 : "跌"]
    let levelIconMap = [1 : "priceUpIcon", 2 : "noneImage", 3 : "priceDownIcon"]
    let levelTextColorMap: [Int : UIColor] = [1 : .setPriceUp(), 2 : .setPriceNormal(), 3 : .setPriceDown()]
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial?
    
    
    
    @IBOutlet var naviBar: UINavigationBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gradientView: UIView! {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = [UIColor.set(red: 7, green: 81, blue: 107).cgColor, UIColor.set(red: 5, green: 19, blue: 43).cgColor]
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientView.layer.addSublayer(gradientLayer)
        }
    }
    
    @IBOutlet var dieselOilWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var oilChangeLabel: UILabel!
    @IBOutlet var dieselOilChangeLabel: UILabel!
    @IBOutlet var dieselOilLevelImageView: UIImageView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var levelTextLabel: UILabel!
    @IBOutlet var levelIconImageView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        naviBar.setBackgroundImage(image, for: .default)
        naviBar.shadowImage = image
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "OilCollectionViewCell", bundle: nil)
        
        collectionViewHeightConstraint.constant = CGFloat(cellHeight * CGFloat(oilNameArr.count) + CGFloat(60))
        collectionView.register(nib, forCellWithReuseIdentifier: "OilCollectionViewCell")
        
        DataManager.shared.getOil { (data) -> (Void) in
            guard let data = data?.results.first else { return }
            self.cnpcPriceArr = [String]()
            self.formosaPriceArr = [String]()
            
            self.cnpcPriceArr.append("中油  \(data.cpcOil92)")
            self.cnpcPriceArr.append("中油  \(data.cpcOil98)")
            self.cnpcPriceArr.append("中油  \(data.cpcOil95)")
            self.cnpcPriceArr.append("中油  \(data.cpcDieselOil)")
            
            self.formosaPriceArr.append("台塑  \(data.fpcOil92)")
            self.formosaPriceArr.append("台塑  \(data.fpcOil95)")
            self.formosaPriceArr.append("台塑  \(data.fpcOil98)")
            self.formosaPriceArr.append("台塑  \(data.fpcDieselOil)")
            
            
            DispatchQueue.main.async {
                self.levelTextLabel.text = self.levelTextMap[data.priceLevelDisel]
                self.levelIconImageView.image = UIImage(named: self.levelIconMap[data.priceLevelDisel] ?? "")
                self.levelTextLabel.textColor = self.levelTextColorMap[data.priceLevelDisel]
                self.shareMessage = "下週油價漲幅預測，漲 \(data.oilChange)"
                
                self.oilChangeLabel.text = "\(data.oilChange)"
                self.oilChangeLabel.textColor = self.levelTextColorMap[data.priceLevelDisel]
                
                self.dieselOilChangeLabel.text = "\(data.dieselChange)"
                self.dieselOilChangeLabel.textColor = self.levelTextColorMap[data.priceLevelDisel]
                self.dieselOilLevelImageView.image = UIImage(named: self.levelIconMap[data.priceLevelDisel] ?? "")
                
                self.dieselOilWidthConstraint.constant = data.priceLevelDisel == 2 ? 0 : self.dieselOilWidthConstraint.constant
                
                self.collectionView.reloadData()
            }
        }
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-1109779512560033/1833493055"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    @IBAction func onMenuPageClick(_ sender: UIBarButtonItem) {
        let menuVC = MenuVC.loadFromNib()
        menuVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    @IBAction func onShareClick(_ sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                self.interstitial = self.createAndLoadInterstitial()
            }
        }
        // 顯示出我們的 activityVC。
        self.present(activityVC, animated: true)
    }
    
    /// 加入橫幅廣告頁面
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view.safeAreaLayoutGuide,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    /// 加入插頁式廣告頁面
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1109779512560033/7553767489")
        guard let interstitial = interstitial else { return nil }
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        return interstitial
    }
    
}

extension OilVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return oilNameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OilCollectionViewCell", for: indexPath) as! OilCollectionViewCell
        cell.oilNameLabel.text = oilNameArr[indexPath.row]
        cell.cnpcPrice.text = cnpcPriceArr[indexPath.row]
        cell.formosaPrice.text = formosaPriceArr[indexPath.row]
        
        return cell
    }
    
    
}

extension OilVC: UICollectionViewDelegate {
    
}

// MARK: - 設定 CollectionView Cell 與 Cell 之間的間距、距確 Super View 的距離等等
extension OilVC: UICollectionViewDelegateFlowLayout {
    
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 362 * screenScaleWidth , height: cellHeight)
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

extension OilVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")

        addBannerViewToView(bannerView)
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension OilVC: GADInterstitialDelegate {

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
