//
//  OilVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/2.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Network

class OilVC: UIViewController {
    
    let monitor = NWPathMonitor()
    var oilModel: OilModel?
    let oilNameArr = ["92  無鉛", "95  無鉛", "98  無鉛", "高級柴油"]
    var cnpcPriceArr = ["        ", "        ", "        ", "        "]
    var formosaPriceArr = ["        ", "        ", "        ", "        "]
    var oilCompareArr = [0, 1, 2, 1]
    let cellHeight = 60 * screenSceleHeight
    var shareMessage = ""
    let levelTextMap = [0 : "持平", 1 : "低", 2 : "高"]
    let levelIconMap = [0 : "noneIcon", 1 : "priceDownIcon", 2 : "priceUpIcon"]
    let levelTextColorMap: [Int : UIColor] = [0 : .setPriceNormal(), 1 : .setPriceDown(), 2 : .setPriceUp()]
    
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
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var oilTitleLabel: UILabel!
    @IBOutlet var dieselOilWidthConstraint: NSLayoutConstraint!
    @IBOutlet var levelIconWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var oilChangeLabel: UILabel!
    @IBOutlet var dieselOilChangeLabel: UILabel!
    @IBOutlet var dieselOilLevelImageView: UIImageView!
    @IBOutlet var averageLabel: UILabel!
    @IBOutlet var averageIconImageView: UIImageView!
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
        isConnect()
        
        let nib = UINib(nibName: "OilCollectionViewCell", bundle: nil)
        
        collectionViewHeightConstraint.constant = CGFloat(cellHeight * CGFloat(oilNameArr.count) + CGFloat(96))
        collectionView.register(nib, forCellWithReuseIdentifier: "OilCollectionViewCell")
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-4291784641323785/5225318746"
        bannerView.rootViewController = self
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        activityIndicatorView.layer.cornerRadius = 8 * screenScaleWidth
        

        getOilData()
        
    }
    
    func getOilData() {
        guard let data = self.oilModel?.results.first else { return }
        self.cnpcPriceArr = [String]()
        self.formosaPriceArr = [String]()
        self.oilCompareArr = [Int]()
        
        self.cnpcPriceArr.append("中油  \(data.cpcOil92)")
        self.cnpcPriceArr.append("中油  \(data.cpcOil95)")
        self.cnpcPriceArr.append("中油  \(data.cpcOil98)")
        self.cnpcPriceArr.append("中油  \(data.cpcDieselOil)")
        
        self.formosaPriceArr.append("台塑  \(data.fpcOil92)")
        self.formosaPriceArr.append("台塑  \(data.fpcOil95)")
        self.formosaPriceArr.append("台塑  \(data.fpcOil98)")
        self.formosaPriceArr.append("台塑  \(data.fpcDieselOil)")
        
        // 0: 持平, 1:中油低於台塑, 2: 台塑低於中油
        self.oilCompareArr.append(data.cpcOil92 == data.fpcOil92 ? 0 : data.cpcOil92 < data.fpcOil92 ? 1 : 2)
        self.oilCompareArr.append(data.cpcOil95 == data.fpcOil95 ? 0 : data.cpcOil95 < data.fpcOil95 ? 1 : 2)
        self.oilCompareArr.append(data.cpcOil98 == data.fpcOil98 ? 0 : data.cpcOil98 < data.fpcOil98 ? 1 : 2)
        self.oilCompareArr.append(data.cpcDieselOil == data.fpcDieselOil ? 0 : data.cpcDieselOil < data.fpcDieselOil ? 1 : 2)
        
        DispatchQueue.main.async {
            
            // 一般油價
            self.oilChangeLabel.text = "\(data.oilChange)"
            switch data.oilChange {
            case 0:
                self.levelTextLabel.text = "持平"
                self.levelTextLabel.textColor = .setPriceNormal()
                self.levelIconImageView.image = UIImage(named: "noneIcon")
                self.oilChangeLabel.textColor = .setPriceNormal()
            case 0...:
                self.levelTextLabel.text = "漲"
                self.levelTextLabel.textColor = .setPriceUp()
                self.levelIconImageView.image = UIImage(named: "priceUpIcon")
                self.oilChangeLabel.textColor = .setPriceUp()
            case ..<0:
                self.levelTextLabel.text = "跌"
                self.levelTextLabel.textColor = .setPriceDown()
                self.levelIconImageView.image = UIImage(named: "priceDownIcon")
                self.oilChangeLabel.textColor = .setPriceDown()
                self.oilChangeLabel.text = "\(data.oilChange * -1)"
            default:
                break
            }
          
            // 柴油油價
            self.dieselOilChangeLabel.text = "\(data.dieselChange)"
            switch data.dieselChange {
            case 0:
                self.dieselOilChangeLabel.textColor = .setPriceNormal()
                self.dieselOilChangeLabel.textColor = .setPriceNormal()
                self.dieselOilLevelImageView.image = UIImage(named: "noneIcon")
                self.dieselOilWidthConstraint.constant = 0
            case 0...:
                self.dieselOilChangeLabel.textColor = .setPriceUp()
                self.dieselOilChangeLabel.textColor = .setPriceUp()
                self.dieselOilLevelImageView.image = UIImage(named: "priceUpIcon")
            case ..<0:
                self.dieselOilChangeLabel.textColor = .setPriceDown()
                self.dieselOilChangeLabel.textColor = .setPriceDown()
                self.dieselOilLevelImageView.image = UIImage(named: "priceDownIcon")
                self.dieselOilChangeLabel.text = "\(data.dieselChange * -1)"
            default:
                break
            }
            
            // 平均
            self.averageLabel.text = self.levelTextMap[data.priceLevel95]
            self.averageLabel.textColor = self.levelTextColorMap[data.priceLevel95]
            self.averageIconImageView.image = UIImage(named: self.levelIconMap[data.priceLevel95] ?? "")
            self.levelIconWidthConstraint.constant = data.priceLevel95 == 0 ? 0 : self.levelIconWidthConstraint.constant
            
            let today = Date()
            let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
            let weekday = dateComponents.weekday!
            
            switch weekday {
            case 1:     // 星期日
                self.oilTitleLabel.text = data.announceStatus ? "中油公告明日油價" : "明日油價預測"
            case 2:     // 星期一
                self.oilTitleLabel.text = data.announceStatus ? "中油公告本週油價" : "本週油價預測"
            case 3 ... 7:   // 星期三~六
                self.oilTitleLabel.text = "預測下週油價"
            default:
                break
            }
            
            self.shareMessage = "生活小百科提醒： \(self.oilTitleLabel.text ?? "油價漲幅")，漲 \(data.oilChange)"
            
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
//            self.collectionView.reloadData()
        }
    }
    /// 錯誤請求 Alert
    func apiErrorAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "載入失敗", message: "資料更新中，請稍後再試", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "完成", style: .cancel) { _ in
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func isConnect() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("connected")
            } else {
                print("no connection")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "網路中斷", message: "為了更好的APP使用體驗，請檢查您的網路連線", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "完成", style: .cancel) { _ in
                        print("done")
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                    }
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    @IBAction func onMenuPageClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onShareClick(_ sender: UIBarButtonItem) {
        let shareUrlStr = "https://apps.apple.com/tw/app/生活小百科/id1515688778"
        let activityVC = UIActivityViewController(activityItems: [shareMessage, shareUrlStr], applicationActivities: nil)
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
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4291784641323785/8037037113")
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
        cell.setOilAttr(cnpcStr: cnpcPriceArr[indexPath.row], formosaStr: formosaPriceArr[indexPath.row], oilLevel: oilCompareArr[indexPath.row], cnpc: cell.cnpcPrice, formosa: cell.formosaPrice)
        
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
        return UIEdgeInsets(top: 18, left: 26, bottom: 18, right: 26)
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
