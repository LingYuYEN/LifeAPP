//
//  ViewController.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/25.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds
class ViewController: UIViewController {
    
    @IBOutlet var adBannerView: UIView!
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1109779512560033/5958433025"
        bannerView.delegate = self
        bannerView.rootViewController = self
        return bannerView
    }()
    
    @IBOutlet var gradientView: UIView! {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = [UIColor.set(red: 4, green: 190, blue: 254).cgColor, UIColor.set(red: 68, green: 129, blue: 235).cgColor]
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientView.layer.addSublayer(gradientLayer)
        }
    }
    
    @IBOutlet var contentView: UIView! {
        didSet {
            contentView.frame.size.width = screen.width
        }
    }
    
    @IBOutlet var stackContentViewFirst: UIView!
    @IBOutlet var stackContentViewSec: UIView!
    @IBOutlet var stackContentViewThird: UIView!
    
    @IBOutlet var wetherViewFirst: UIView!
    @IBOutlet var wetherViewSec: UIView!
    @IBOutlet var wetherViewThrid: UIView!
    
    @IBOutlet var weekendCollectionView: UICollectionView!
    @IBOutlet var nowTempLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var todayDTXLabel: UILabel!
    @IBOutlet var todayDTNLabel: UILabel!
    @IBOutlet var aqiLabel: UILabel!
    @IBOutlet var uviLabel: UILabel!
    @IBOutlet var popLabel: UILabel!
    
    @IBOutlet var aqiStatusImage: UIImageView!
    @IBOutlet var aqiDangerImage: UIImageView!
    @IBOutlet var uviStatusImage: UIImageView!
    @IBOutlet var uviDangerImage: UIImageView!
    @IBOutlet var popStatusImage: UIImageView!
    @IBOutlet var popDangerImage: UIImageView!
    
    
    let week = ["五", "六", "日", "一", "二", "三"]
    let wetherImageName = ["group6Copy", "group6Copy", "group6Copy", "group6Copy", "group6Copy", "group6Copy"]
    let hightT = ["26°", "25°", "22°", "28°", "25°", "20°"]
    let lowT = ["22°", "20°", "18°", "23°", "19°", "16°"]
    let baseUrl = DataManager.shared.baseUrl
    let wetherApiKey = DataManager.shared.wetherApiKey
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let barAppearance =  UINavigationBarAppearance()
            barAppearance.configureWithTransparentBackground()
            navigationController?.navigationBar.standardAppearance = barAppearance
        }
        
        
        setWetherView(wetherView: wetherViewFirst, gradientView: stackContentViewFirst)
        setWetherView(wetherView: wetherViewSec, gradientView: stackContentViewSec)
        setWetherView(wetherView: wetherViewThrid, gradientView: stackContentViewThird)
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        bannerView.load(GADRequest())
        
        let nib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        let imageNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.weekendCollectionView.register(nib, forCellWithReuseIdentifier: "TextCollectionViewCell")
        self.weekendCollectionView.register(imageNib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        let urlStr = "\(baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(wetherApiKey)&parameterName=CITY"
        getWetherData(urlStr: urlStr)
        
        let aqiUrl = "https://opendata.epa.gov.tw/webapi/Data/AQI/?$skip=0&$top=1000&format=json"
        getAQIData(urlStr: aqiUrl)
        
        let uviUrl = "https://opendata.epa.gov.tw/webapi/Data/UV/?$skip=0&$top=1000&format=json"
        getUVIData(urlStr: uviUrl)
        
        let popUrl = "\(baseUrl)/v1/rest/datastore/F-C0032-001?Authorization=\(wetherApiKey)&locationName=%E9%AB%98%E9%9B%84%E5%B8%82&elementName=PoP"
        getPopData(urlStr: popUrl)
    }
    
    func setUI() {
        DispatchQueue.main.async {
            self.symbolLabel.isHidden = self.nowTempLabel.text == "-" ? true : false
        }
    }
    
    
    /// 取得天氣資訊
    func getWetherData(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let wetherModel = try JSONDecoder().decode(WetherModel.self, from: data)
                for location in wetherModel.records.location {
                    if location.locationName == "高雄" {
                        for weatherElement in location.weatherElement {
                            switch weatherElement.elementName {
                            case .temp:
                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.nowTempLabel, symbol: false)
                            case .dTx:
                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.todayDTXLabel, symbol: true)
                            case .dTn:
                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.todayDTNLabel, symbol: true)
                            default:
                                break
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    /// 取得空氣品質指標
    func getAQIData(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let aqiModels = try JSONDecoder().decode(AQIModel.self, from: data)
                
                for aqiModel in aqiModels {
                    DispatchQueue.main.async {
                        switch aqiModel.status {
                        case .良好:
                            self.aqiLabel.text = "空氣品質良好"
                            self.aqiStatusImage.image = UIImage(named: "smileIcon")
                            self.aqiDangerImage.isHidden = true
                        case .普通:
                            self.aqiLabel.text = "空氣品質普通"
                            self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.aqiDangerImage.isHidden = false
                        default:
                            self.aqiLabel.text = "空氣品質差"
                            self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
                            self.aqiDangerImage.isHidden = false
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    /// 取得紫外線指標
    func getUVIData(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let uviModels = try JSONDecoder().decode(UVIModel.self, from: data)
                
                for uviModel in uviModels {
                    DispatchQueue.main.async {
                        switch uviModel.publishAgency {
                        case .中央氣象局:
                            guard let uviDouble = Double(uviModel.uvi) else { return }
                            switch lrint(uviDouble) {
                            case 0 ... 2:
                                self.uviLabel.text = "紫外線低"
                                self.uviStatusImage.image = UIImage(named: "smileIcon")
                                self.uviDangerImage.isHidden = true
                            case 3 ... 5:
                                self.uviLabel.text = "紫外線中量"
                                self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
                                self.uviDangerImage.isHidden = true
                            case 6 ... 7:
                                self.uviLabel.text = "紫外線高"
                                self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                                self.uviDangerImage.isHidden = false
                            case 8 ... 10:
                                self.uviLabel.text = "紫外線過量"
                                self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                                self.uviDangerImage.isHidden = false
                            default:
                                self.uviLabel.text = "紫外線危險"
                                self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                                self.uviDangerImage.isHidden = false
                            }
                        case .環境保護署:
                            break
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    /// 取得降雨機率指標
    func getPopData(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let popModel = try JSONDecoder().decode(POPModel.self, from: data)
                guard let popElement = popModel.records.location.first?.weatherElement.first?.time.first?.parameter.parameterName else { return }
                DispatchQueue.main.async {
                    self.popLabel.text = "降雨機率 \(popElement)％"
                    guard let intPopElement = Int(popElement) else { return }
                    switch intPopElement {
                    case 0 ... 10:
                        self.popStatusImage.image = UIImage(named: "smileIcon")
                        self.popDangerImage.isHidden = true
                    case 11 ... 30:
                        self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                        self.popDangerImage.isHidden = true
                    default:
                        self.popStatusImage.image = UIImage(named: "unsmileIcon")
                        self.popDangerImage.isHidden = false
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    /// 將取得的溫度轉換成整數並置入Label，是否包含符號
    func convertTemperature(temperatureStr: String, inputLabel: UILabel, symbol: Bool) {
        switch symbol {
        case true:
            if let temperatureDouble = Double(temperatureStr) {
                DispatchQueue.main.async {
                    inputLabel.text = "\(lround(temperatureDouble))°"
                }
            }
        case false:
            if let temperatureDouble = Double(temperatureStr) {
                DispatchQueue.main.async {
                    inputLabel.text = "\(lround(temperatureDouble))"
                }
            }
        }
        setUI()
    }
    
    
    func setWetherView(wetherView: UIView, gradientView: UIView) {
        // 不知為什麼 storyboard 的 layout 沒有響應，所以再自行設定一次寬度比例
        wetherView.frame.size.width = 362 * screenScaleWidth
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8
        gradientLayer.frame = wetherView.bounds
        
        gradientLayer.colors = [UIColor.set(red: 0, green: 171, blue: 255).cgColor, UIColor.set(red: 0, green: 152, blue: 249).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientView.layer.addSublayer(gradientLayer)
        
        wetherView.layer.cornerRadius = 8
        wetherView.layer.borderWidth = 1
        wetherView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        wetherView.layer.applySketchShadow(color: .set(red: 255, green: 0, blue: 0), alpha: 0.19, x: 1.3, y: 1.3, blur: 3.7, spread: 0)
    }


}

extension ViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")

//        self.adBannerView.frame = bannerView.frame
//        self.adBannerView = bannerView
        
        // 重新調整橫幅廣告位置來建立滑下特效
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform

        UIView.animate(withDuration: 0.5) {
            self.adBannerView.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.adBannerView = bannerView
        }
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return week.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell", for: indexPath) as! TextCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel.text = week[indexPath.row]
            cell.textLabel.font = UIFont(name: "PingFangTC-Regular", size: 17)
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            cell.imageView.image = UIImage(named: wetherImageName[indexPath.row])
            return cell
        case 2:
            cell.textLabel.text = hightT[indexPath.row]
            
        case 3:
            cell.textLabel.text = lowT[indexPath.row]
            
        default:
            break
        }
        
        return cell
    }
}


extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - 設定 CollectionView Cell 與 Cell 之間的間距、距確 Super View 的距離等等
extension ViewController: UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: (collectionView.frame.size.width - (44 * screenScaleWidth)) / 6 , height: (collectionView.frame.size.height - (15 * screen.height / 985)) / 4)
    }
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 * screenSceleHeight
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
