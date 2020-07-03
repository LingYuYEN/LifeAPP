//
//  TicketVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseFirestore
import FirebaseCore

class TicketVC: UIViewController {

    
    @IBOutlet var naviBar: UINavigationBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    
    
//    var titleNames = ["3000 元 振興三倍券", "800 元 振興抵用券", "600 元 藝FUN券", "250 元 農遊券"]
//    var memoNames = ["介紹 ＆ 領取 ＆ 使用懶人包", "介紹 ＆ 領取 ＆ 使用懶人包", "介紹 ＆ 領取 ＆ 使用懶人包", "介紹 ＆ 領取 ＆ 使用懶人包"]
//    var urlStrs = ["https://3coupon.info/eli5/treble/", "https://3coupon.info/eli5/voucher/", "https://3coupon.info/eli5/fun/", "https://3coupon.info/eli5/farming/"]
    
    var titleNames = [String]()
    var memoNames = [String]()
    var urlStrs = [String]()
    
    var bannerView: GADBannerView!
    var db: Firestore!
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                              NSAttributedString.Key.kern: 1,
                                                              NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 21)!]
        naviBar.titleTextAttributes = textAttributes
        
        let image = UIImage()
        naviBar.setBackgroundImage(image, for: .default)
        naviBar.shadowImage = image
        
        // 取消預設 back icon
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        
        self.navigationController?.navigationBar.isHidden = true
        
        // 為了不讓 navigationController offset
        self.navigationController?.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 移除分隔線
        let image = UIImage()
                
        segmentControl.setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segmentControl.setTitleTextAttributes([.foregroundColor : UIColor.black, .kern : CGFloat(1), .font : UIFont(name: "PingFangTC-Regular", size: CGFloat(17))!], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor : UIColor.set(red: 242, green: 115, blue: 112), .kern : CGFloat(1), .font : UIFont(name: "PingFangTC-Regular", size: CGFloat(17))!], for: .normal)
        
        let nib = UINib(nibName: "TicketCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TicketCollectionViewCell")
        
        db = Firestore.firestore()
        readData(documentName: "revitalize")
        
        setUI()
    }
    
    func readData(documentName: String){
        
        // 取得 lifeAppData 這個 collection
        db.collection("lifeAppData").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dataArr = document.data()[documentName] as! [[String: String]]
                    
                    var newTitleNames = [String]()
                    var newMemoNames = [String]()
                    var newUrlStrs = [String]()
                    
                    for data in dataArr {
                        if let name = data["name"], let memo = data["memo"], let url = data["url"] {
                            newTitleNames.append(name)
                            newMemoNames.append(memo)
                            newUrlStrs.append(url)
                        }
                    }
                    
                    self.titleNames = newTitleNames
                    self.memoNames = newMemoNames
                    self.urlStrs = newUrlStrs
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setUI() {
        loadBannerView()
    }
    
    func loadBannerView() {
            self.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            self.bannerView.adUnitID = "ca-app-pub-4291784641323785/5225318746"
            self.bannerView.rootViewController = self
            
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
            self.bannerView.load(GADRequest())
            self.bannerView.delegate = self
        }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            
            readData(documentName: "revitalize")
            
//            titleNames = ["3000 元 振興三倍券", "800 元 振興抵用券", "600 元 藝FUN券", "250 元 農遊券"]
//            memoNames = ["介紹 ＆ 領取 ＆ 使用懶人包", "介紹 ＆ 領取 ＆ 使用懶人包", "介紹 ＆ 領取 ＆ 使用懶人包", "介紹 ＆ 領取 ＆ 使用懶人包"]
//            urlStrs = ["https://3coupon.info/eli5/treble/", "https://3coupon.info/eli5/voucher/", "https://3coupon.info/eli5/fun/", "https://3coupon.info/eli5/farming/"]
        case 1:
            readData(documentName: "tourism")
//            titleNames = ["安心旅遊補助", "自由行住宿補助", "自由行遊樂園門票補助", "自由行台灣觀光巴士優惠"]
//            memoNames = ["介紹 ＆ 補助期間", "介紹 ＆ 辦法懶人包", "介紹 ＆ 辦法懶人包", "介紹 ＆ 辦法懶人包"]
//            urlStrs = ["https://3coupon.info/eli5/tour/", "https://3coupon.info/eli5/tour/", "https://3coupon.info/eli5/tour/", "https://3coupon.info/eli5/tour/"]
        case 2:
            readData(documentName: "countryPlus")
//            titleNames = ["台北市", "新北市", "基隆市", "宜蘭縣", "桃園市", "新竹縣", "新竹市", "苗栗縣", "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "嘉義市", "台南市", "高雄市", "屏東縣", "花蓮縣", "台東縣", "金門縣", "連江縣", "澎湖縣"]
//            memoNames = ["「台北GO了沒？」安心旅遊專案", "「新北振興一路發」優惠專案", "基隆市", "宜蘭縣", "加碼推出五百元電子旅遊券", "新竹縣", "加碼推出面額500元消費券", "苗栗縣", "台中購物節將推出「振興券抽獎獎項」", "彰化縣", "南投縣", "雲林縣", "搭配國旅補助，限量發放「嘉義優鮮券」", "嘉義市", "台南市", "高雄市", "屏東縣", "花蓮縣", "台東縣", "金門縣", "連江縣", "加碼發放每人500元消費券"]
//            urlStrs = [
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/",
//                "https://3coupon.info/eli5/county/"
//            ]
        default:
            break
        }
        collectionView.reloadData()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 加入橫幅廣告頁面
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.bringSubviewToFront(bannerView)
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

}

extension TicketVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCollectionViewCell", for: indexPath) as! TicketCollectionViewCell
        cell.titleLabel.text = titleNames[indexPath.row]
        cell.memoLabel.text = memoNames[indexPath.row]
        
        return cell
    }
    
    
}
extension TicketVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ticketDetailVC = TicketDetailVC.loadFromNib()
        ticketDetailVC.urlStr = urlStrs[indexPath.row]
        ticketDetailVC.modalPresentationStyle = .fullScreen
        self.present(ticketDetailVC, animated: true, completion: nil)
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
        return UIEdgeInsets(top: 20, left: 25 * screenScaleWidth, bottom: 20, right: 25 * screenScaleWidth)
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 364 * screenScaleWidth , height: 100 * screenSceleHeight)
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

extension TicketVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        addBannerViewToView(bannerView)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}
