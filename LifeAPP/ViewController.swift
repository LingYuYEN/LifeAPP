//
//  ViewController.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/25.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreLocation

class ViewController: UIViewController {
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial?
    
    @IBOutlet var pickerContentView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var refreshView: UIActivityIndicatorView!
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
    
    @IBOutlet var refreshBtnItem: UIBarButtonItem!
    @IBOutlet var shareBtnItem: UIBarButtonItem!
    
    
    
    @IBOutlet var stackContentViewFirst: UIView!
    @IBOutlet var stackContentViewSec: UIView!
    @IBOutlet var stackContentViewThird: UIView!
    
    @IBOutlet var wetherViewFirst: UIView!
    @IBOutlet var wetherViewSec: UIView!
    @IBOutlet var wetherViewThrid: UIView!
    
    @IBOutlet var weekendCollectionView: UICollectionView!
    @IBOutlet var nowTempLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    
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
    
    @IBOutlet var locationsBtn: UIButton!
    var myLocationManager: CLLocationManager!
    
    var intWeekArr = [Int]()
    var chWeekArr = [String]()
    var oneWeekMaxTemp = [String]()
    var oneWeekMinTemp = [String]()
    
    let locationArr = [
        "台北市", "新北市", "基隆市", "宜蘭縣", "桃園市", "新竹縣", "新竹市", "苗栗縣", "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "嘉義市", "台南市", "高雄市", "屏東縣", "花蓮縣", "台東縣", "金門縣", "連江縣", "澎湖縣"
    ]
    let weekArr = ["五", "六", "日", "一", "二", "三"]
    let wetherImageName = ["group6Copy", "group6Copy", "group6Copy", "group6Copy", "group6Copy", "group6Copy"]
    let hightT = ["26°", "25°", "22°", "28°", "25°", "20°"]
    let lowT = ["22°", "20°", "18°", "23°", "19°", "16°"]
    let baseUrl = DataManager.shared.baseUrl
    let wetherApiKey = DataManager.shared.wetherApiKey
    
    var testMessage = "這個是測試的分享訊息............!!"
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
        // 首次使用 向使用者詢問定位自身位置權限
        getAuthorization()
        
        view.addSubview(pickerContentView)
        pickerContentView.translatesAutoresizingMaskIntoConstraints = false
        pickerContentView.heightAnchor.constraint(equalToConstant: 216).isActive = true
        pickerContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pickerContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        let pickerBottomAnchor = pickerContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 216)
        pickerBottomAnchor.identifier = "bottom"
        pickerBottomAnchor.isActive = true
        super.viewWillAppear(animated)
        
    }
    
    // 首次使用 向使用者詢問定位自身位置權限
    func getAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()

            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        
        }
        // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
              title: "定位權限已關閉",
              message:
              "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
              preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
              alertController,
              animated: true, completion: nil)
        }
        // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 必須將 locationsBtn 指向 titleView 才可使用
        self.navigationItem.titleView = locationsBtn
        
        refreshView.layer.cornerRadius = 15
        
        // 經緯度管理
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        guard let lat = myLocationManager.location?.coordinate.latitude else { return }
        guard let lon = myLocationManager.location?.coordinate.longitude else { return }
        // 取得使用者座標並更新數據
        locationAddress(latitude: lat, longitude: lon) {
//            self.setUI()
        }
        
        if #available(iOS 13.0, *) {
            let barAppearance =  UINavigationBarAppearance()
            barAppearance.configureWithTransparentBackground()
            navigationController?.navigationBar.standardAppearance = barAppearance
        }
        
        
        setWetherView(wetherView: wetherViewFirst, gradientView: stackContentViewFirst)
        setWetherView(wetherView: wetherViewSec, gradientView: stackContentViewSec)
        setWetherView(wetherView: wetherViewThrid, gradientView: stackContentViewThird)
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-1109779512560033/1833493055"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        // 載入插頁式廣告
//        interstitial = createAndLoadInterstitial()
        
        let nib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        let imageNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.weekendCollectionView.register(nib, forCellWithReuseIdentifier: "TextCollectionViewCell")
        self.weekendCollectionView.register(imageNib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        locationsBtn.addTarget(self, action: #selector(onSelectLocationClick), for: .touchUpInside)
        
        setupUI()
    }
    
    @objc func onSelectLocationClick(_ sender: UIButton) {
        pickerViewIsHidden(bool: false)
        
    }
    @IBAction func onRefreshClick(_ sender: UIBarButtonItem) {
        refreshView.isHidden = false
        guard let lat = myLocationManager.location?.coordinate.latitude else { return }
        guard let lon = myLocationManager.location?.coordinate.longitude else { return }
        
        // 取得使用者座標並更新數據
        locationAddress(latitude: lat, longitude: lon) {
            
        }
        
        
    }
    @IBAction func onShareClick(_ sender: UIBarButtonItem) {
//        interstitial = createAndLoadInterstitial()
        // activityItems 陣列中放入我們想要使用的元件，這邊我們放入使用者圖片、使用者名稱及個人部落格。
        // 這邊因為我們確認裡面有值，所以使用驚嘆號強制解包。
        let activityVC = UIActivityViewController(activityItems: [testMessage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                self.interstitial = self.createAndLoadInterstitial()
            }
        }
        // 顯示出我們的 activityVC。
        self.present(activityVC, animated: true)
    }
    
    @IBAction func onPickerViewDoneClick(_ sender: UIButton) {
        refreshView.isHidden = false
        let location = locationArr[pickerView.selectedRow(inComponent: 0)]
        selectLocationCity(cityStr: location) {
            self.locationsBtn.setTitle(location, for: .normal)
        }
        pickerViewIsHidden(bool: true)
        
    }
    @IBAction func onPickerViewCancelClick(_ sender: UIButton) {
        pickerViewIsHidden(bool: true)
    }
    
    func setupUI() {
        
        let chineseWeekDic = ["Monday" : "一", "Tuesday" : "二", "Wednesday" : "三", "Thursday" : "四", "Friday" : "五", "Saturday" : "六", "Sunday" : "日"]
        let enToIntDic: [String : Int] = ["Monday" : 1, "Tuesday" : 2, "Wednesday" : 3, "Thursday" : 4, "Friday" : 5, "Saturday" : 6, "Sunday" : 7]
        let intToStrDic = [1 : "一", 2 : "二", 3 : "三", 4 : "四", 5 : "五", 6 : "六", 7 : "日"]
        // 5 / 21 ( 四 ) 13 : 50
        let now = Date()
        /// Date 格式化
        let dateFormatter = DateFormatter()     // 建立日期格式化器
        dateFormatter.locale = Locale.current   // 格式化為當地時間
        dateFormatter.dateFormat = "EEEE"
        let weekDateFormatter = dateFormatter.string(from: now)
        guard let chineseWeek = chineseWeekDic[weekDateFormatter] else { return }
        guard var intWeek = enToIntDic[weekDateFormatter] else { return }
        dateFormatter.dateFormat = "M / dd ( \(chineseWeek) ) hh : mm" // 格式化顯示型態
        let nowFormatter = dateFormatter.string(from: now)  // 將現在時間格式化
        
        while intWeekArr.count < 6 {
            intWeek += 1
            if intWeek > 7 {
                intWeek = 1
            }
            
            intWeekArr.append(intWeek)
            guard let todayWeekCh = intToStrDic[intWeek] else { return }
            chWeekArr.append(todayWeekCh)
        }

        print(chWeekArr)
        dateLabel.text = "\(nowFormatter)"
    }
    
    func pickerViewIsHidden(bool: Bool) {
        for constraint in view.constraints {
            if constraint.identifier == "bottom" {
                constraint.constant = bool ? 166 : -50
                break
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    /// 透過 pickerView 選擇後的資料取得
    func selectLocationCity(cityStr: String, _ completion: @escaping () -> Void) {
        defer {
            DispatchQueue.main.async {
                completion()
            }
        }
        
        DispatchQueue.main.async {
            let locationNameDic: Dictionary = [
                "台北市" : "臺北",
                "新北市" : "土城",
                "基隆市" : "基隆",
                "宜蘭縣" : "宜蘭",
                "桃園市" : "桃園",
                "新竹縣" : "新竹",
                "新竹市" : "新竹市東區",
                "苗栗縣" : "苗栗",
                "台中市" : "臺中",
                "彰化縣" : "員林",
                "南投縣" : "南投",
                "雲林縣" : "斗六",
                "嘉義縣" : "太保",
                "嘉義市" : "嘉義市東區",
                "台南市" : "臺南",
                "高雄市" : "高雄",
                "屏東縣" : "恆春",
                "花蓮縣" : "花蓮",
                "台東縣" : "臺東",
                "金門縣" : "金沙",
                "連江縣" : "東引",
                "澎湖縣" : "澎湖",
            ]

            let aqiLocationNameDic: Dictionary = [
                "台北市" : "臺北市",
                "新北市" : "新北市",
                "基隆市" : "基隆市",
                "宜蘭縣" : "宜蘭縣",
                "桃園市" : "桃園市",
                "新竹縣" : "新竹縣",
                "新竹市" : "新竹市",
                "苗栗縣" : "苗栗縣",
                "台中市" : "臺中市",
                "彰化縣" : "彰化縣",
                "南投縣" : "南投縣",
                "雲林縣" : "雲林縣",
                "嘉義縣" : "嘉義縣",
                "嘉義市" : "嘉義市",
                "台南市" : "臺南市",
                "高雄市" : "高雄市",
                "屏東縣" : "屏東縣",
                "花蓮縣" : "花蓮縣",
                "台東縣" : "台東縣",
                "金門縣" : "金門縣",
                "連江縣" : "連江縣",
                "澎湖縣" : "澎湖縣"
            ]
            
            // 套用 url 的各縣市站點名稱
            guard let newCity = locationNameDic[cityStr] else { return }
            guard let aqiNewCity = aqiLocationNameDic[cityStr] else { return }
            let urlStr = "\(self.baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(self.wetherApiKey)&parameterName=CITY"

            self.getWetherData(urlStr: urlStr, locationName: newCity)

            let aqiUrl = "https://opendata.epa.gov.tw/webapi/Data/AQI/?$skip=0&$top=1000&format=json"
            self.getAQIData(urlStr: aqiUrl, locationName: aqiNewCity)

            let uviUrl = "https://opendata.epa.gov.tw/webapi/Data/UV/?$skip=0&$top=1000&format=json"
            self.getUVIData(urlStr: uviUrl)

            let popUrl = "\(self.baseUrl)/v1/rest/datastore/F-C0032-001?Authorization=\(self.wetherApiKey)&locationName=\(cityStr)&elementName=PoP"
            guard let newPopUrl = popUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            self.getPopData(urlStr: newPopUrl)
            
            let oneWeekUrl = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-D0047-091?Authorization=\(self.wetherApiKey)"
            self.getOneWeekWether(urlStr: oneWeekUrl, locationName: cityStr)
        }
        
    }
    
    
    @objc func locationAddress(latitude: Double, longitude: Double, _ completion: @escaping () -> Void){
        defer {
            DispatchQueue.main.async {
                completion()
            }
        }

        /// CLGeocoder地理編碼 經緯度轉換地址位置
        GeocodeManager.shared.geocode(latitude: latitude, longitude: longitude) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                let locationNameDic: Dictionary = [
                    "台北市" : "臺北",
                    "新北市" : "土城",
                    "基隆市" : "基隆",
                    "宜蘭縣" : "宜蘭",
                    "桃園市" : "桃園",
                    "新竹縣" : "新竹",
                    "新竹市" : "新竹市東區",
                    "苗栗縣" : "苗栗",
                    "台中市" : "臺中",
                    "彰化縣" : "員林",
                    "南投縣" : "南投",
                    "雲林縣" : "斗六",
                    "嘉義縣" : "太保",
                    "嘉義市" : "嘉義市東區",
                    "台南市" : "臺南",
                    "高雄市" : "高雄",
                    "屏東縣" : "恆春",
                    "花蓮縣" : "花蓮",
                    "台東縣" : "臺東",
                    "金門縣" : "金沙",
                    "連江縣" : "東引",
                    "澎湖縣" : "澎湖",
                ]

                let aqiLocationNameDic: Dictionary = [
                    "台北市" : "臺北市",
                    "新北市" : "新北市",
                    "基隆市" : "基隆市",
                    "宜蘭縣" : "宜蘭縣",
                    "桃園市" : "桃園市",
                    "新竹縣" : "新竹縣",
                    "新竹市" : "新竹市",
                    "苗栗縣" : "苗栗縣",
                    "台中市" : "臺中市",
                    "彰化縣" : "彰化縣",
                    "南投縣" : "南投縣",
                    "雲林縣" : "雲林縣",
                    "嘉義縣" : "嘉義縣",
                    "嘉義市" : "嘉義市",
                    "台南市" : "臺南市",
                    "高雄市" : "高雄市",
                    "屏東縣" : "屏東縣",
                    "花蓮縣" : "花蓮縣",
                    "台東縣" : "台東縣",
                    "金門縣" : "金門縣",
                    "連江縣" : "連江縣",
                    "澎湖縣" : "澎湖縣"
                ]

                // 定位出來的縣市名稱
                guard let city = placemark.subAdministrativeArea else { return }
                self.locationsBtn.setTitle(placemark.subAdministrativeArea, for: .normal)
                
                // 套用 url 的各縣市站點名稱
                guard let newCity = locationNameDic[city] else { return }
                guard let aqiNewCity = aqiLocationNameDic[city] else { return }
                let urlStr = "\(self.baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(self.wetherApiKey)&parameterName=CITY"

                self.getWetherData(urlStr: urlStr, locationName: newCity)

                let aqiUrl = "https://opendata.epa.gov.tw/webapi/Data/AQI/?$skip=0&$top=1000&format=json"
                self.getAQIData(urlStr: aqiUrl, locationName: aqiNewCity)

                let uviUrl = "https://opendata.epa.gov.tw/webapi/Data/UV/?$skip=0&$top=1000&format=json"
                self.getUVIData(urlStr: uviUrl)

                let popUrl = "\(self.baseUrl)/v1/rest/datastore/F-C0032-001?Authorization=\(self.wetherApiKey)&locationName=\(city)&elementName=PoP"
                guard let newPopUrl = popUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                self.getPopData(urlStr: newPopUrl)
                
                let oneWeekUrl = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-D0047-091?Authorization=\(self.wetherApiKey)"
                self.getOneWeekWether(urlStr: oneWeekUrl, locationName: city)
                
                
            }
        }
    }
    
    
    
    func setUI() {
        DispatchQueue.main.async {
            self.symbolLabel.isHidden = self.nowTempLabel.text == "-" ? true : false
        }
    }
    
    /// 取得天氣資訊
    func getWetherData(urlStr: String, locationName: String) {
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let wetherModel = try JSONDecoder().decode(WetherModel.self, from: data)
                for location in wetherModel.records.location {
                    if location.locationName == locationName {
                        for weatherElement in location.weatherElement {
                            switch weatherElement.elementName {
                            case .temp:
                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.nowTempLabel, symbol: false)
                                self.setUI()
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
    func getAQIData(urlStr: String, locationName: String) {
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let aqiModels = try JSONDecoder().decode(AQIModel.self, from: data)
                
                for aqiModel in aqiModels {
                    if aqiModel.county == locationName {
                        DispatchQueue.main.async {
                            switch aqiModel.status {
                            case .良好:
                                self.aqiLabel.text = "空氣品質良好"
                                self.aqiStatusImage.image = UIImage(named: "smileIcon")
                                self.aqiDangerImage.isHidden = true
                                self.refreshView.isHidden = true
                            case .普通:
                                self.aqiLabel.text = "空氣品質普通"
                                self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
                                self.aqiDangerImage.isHidden = false
                                self.refreshView.isHidden = true
                            case .設備維護:
                                self.aqiLabel.text = "設備維護中..."
                                self.refreshView.isHidden = true
                            default:
                                self.aqiLabel.text = "空氣品質差"
                                self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
                                self.aqiDangerImage.isHidden = false
                                self.refreshView.isHidden = true
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
    
    /// 取得一週（六天）天氣
    func getOneWeekWether(urlStr: String, locationName: String) {
        
        oneWeekMaxTemp = [String]()
        oneWeekMinTemp = [String]()
        let locationNameUrl = "&locationName=\(locationName)"
        guard let newLocationNameUrl = locationNameUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        guard let url = URL(string: urlStr + newLocationNameUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let oneWeekWetherModel = try JSONDecoder().decode(OneWeekWetherModel.self, from: data)
                DispatchQueue.main.async {
                    guard let weatherElements = oneWeekWetherModel.records.locations.first?.location.first?.weatherElement else { return }
                    
                    for weatherElement in weatherElements {
                        if weatherElement.elementName == "MaxT" {
                            
                            for index in stride(from: 0, to: 12, by: 2) {
                                guard let temp = weatherElement.time[index].elementValue.first?.value else { return }
                                self.oneWeekMaxTemp.append(temp + "°")
                            }
                        } else if weatherElement.elementName == "MinT" {
                            for index in stride(from: 1, to: 13, by: 2) {
                                guard let temp = weatherElement.time[index].elementValue.first?.value else { return }
                                self.oneWeekMinTemp.append(temp + "°")
                            }
                        }
                    }
                    self.weekendCollectionView.reloadData()
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
    
    // 加入橫幅廣告頁面
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

    // 加入插頁式廣告頁面
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1109779512560033/7553767489")
        guard let interstitial = interstitial else { return nil }
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        return interstitial
    }

    
}

extension ViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")

        addBannerViewToView(bannerView)
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension ViewController: GADInterstitialDelegate {

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return oneWeekMaxTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell", for: indexPath) as! TextCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel.text = chWeekArr[indexPath.row]
            cell.textLabel.font = UIFont(name: "PingFangTC-Regular", size: 17)
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            cell.imageView.image = UIImage(named: wetherImageName[indexPath.row])
            return cell
        case 2:
            cell.textLabel.text = oneWeekMaxTemp[indexPath.row]
            
        case 3:
            cell.textLabel.text = oneWeekMinTemp[indexPath.row]
            
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

extension ViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        // 印出目前所在位置座標
//        let currentLocation :CLLocation = locations[0] as CLLocation
//        guard let locationLat = Double("\(currentLocation.coordinate.latitude)") else { return }
//        guard let locationLon = Double("\(currentLocation.coordinate.longitude)") else { return }
//
//        print("載入座標及ＡＰＩ資訊: \(locationLat), \(locationLon)")
//        // 將座標轉換成地址，並取得所在縣市
//        locationAddress(latitude: locationLat, longitude: locationLon) {
//            self.myLocationManager = nil
//        }
//
//    }
    
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locationArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.locationArr[row]
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    
    
    
}

