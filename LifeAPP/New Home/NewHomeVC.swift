//
//  NewHomeVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/12.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import CoreLocation
import Network
import GoogleMobileAds

class NewHomeVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    let monitor = NWPathMonitor()
    let locationManager = CLLocationManager()
    
//    let iconImageNames = ["newHomeWeatherIcon", "newHomeOilIcon", "newHomeTicketIcon", "newHomeCityIcon", "newHomeQrcodeIcon", "newHomePostalIcon"]
    let iconImageNames = ["newHomeWeatherIcon", "newHomeOilIcon", "newHomePostalIcon"]

//    let vcIdMap = ["天氣資訊", "油價預測", "三倍券與旅遊振興資訊", "各縣市大型旅遊景點", "發票開獎與掃描對獎", "郵遞區號快速查詢"]
    let vcIdMap = ["天氣資訊", "油價預測", "郵遞區號快速查詢"]
    let vcMap = [0 : "main", 1 : "oilVC", 2 : "ticket", 3 : "ticket", 4 : "ticket", 5 : "ticket"]
    
    var cityTemp = ""
    var maxAndMinTemp = ""
    var pop = ""
    var uvi = ""
    var aqi = ""
    var pm25: Double = 0
    var pm10: Double = 0
    var o3: Double = 0
    var uviDescription = ""
    var isAnnouncement = false
    var oilTitle = ""
    var oilUpAndDownImageName = ""
    var oilUpAndDownText = ""
    var oilChange = ""
    var oilTextColor: UIColor = .clear
    var oil92 = ""
    var oil95 = ""
    var oil98 = ""
    var oilDiesel = ""
    
    var defaultLocation = (25.0375417, 121.562244)
    let defaultCity = "台北市"
    
    var weatherModel: WeatherModel?
    var oilModel: OilModel?
    var refreshControl:UIRefreshControl!
    
    var positionCity = ""
    var oneWeekWx = ["-", "-", "-", "-", "-", "-"]
    var oneWeekMaxTemp = ["-", "-", "-", "-", "-", "-"]
    var oneWeekMinTemp = ["-", "-", "-", "-", "-", "-"]
    
    var shareMessage = ""
    
    var bannerView: GADBannerView!
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
        let backImageView = UIImageView()
        backImageView.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        backImageView.image = UIImage(named: "naviBackIcon")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: backImageView)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "NewHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewHomeCollectionViewCell")
        collectionView.register(UINib(nibName: "NewHomeWeatherCell", bundle: nil), forCellWithReuseIdentifier: "NewHomeWeatherCell")
        collectionView.register(UINib(nibName: "NewHomeOilCell", bundle: nil), forCellWithReuseIdentifier: "NewHomeOilCell")
        
        let attrStr = NSMutableAttributedString(string: "下滑更新最新資訊")
        attrStr.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attrStr.length))
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = attrStr
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        activityIndicatorView.layer.cornerRadius = 8 * screenScaleWidth
        
        isConnect()
        getLocationManager()
        refreshData()
        loadBannerView()
    }
    
    @objc func refreshData() {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            presentDenineAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
        getOilData()
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func getOilData () {
        DataManager.shared.getOil { (model, _) -> (Void) in
            guard let model = model else { return }
            self.oilModel = model
            if let isAnnouncement = model.results.first?.announceStatus,
                let price = model.results.first?.oilChange,
                let oil92 = model.results.first?.cpcOil92,
                let oil95 = model.results.first?.cpcOil95,
                let oil98 = model.results.first?.cpcOil98,
                let oilDiesel = model.results.first?.cpcDieselOil
            {
                self.isAnnouncement = isAnnouncement
                self.oilTitle = isAnnouncement ? "油價公告" : "下週油價預測"
                self.oilChange = "\(price)"
                self.oil92 = "92 無鉛 \(oil92)"
                self.oil95 = "95 無鉛 \(oil95)"
                self.oil98 = "98 無鉛 \(oil98)"
                self.oilDiesel = "柴油 \(oilDiesel)"
                
                switch price {
                case 0:
                    self.oilUpAndDownImageName = ""
                    self.oilUpAndDownText = "平"
                    self.oilTextColor = .setPriceNormal()
                case 0...:
                    self.oilUpAndDownImageName = "priceUpIcon"
                    self.oilUpAndDownText = "漲"
                    self.oilTextColor = .setPriceUp()
                case ..<0:
                    self.oilUpAndDownImageName = "priceDownIcon"
                    self.oilUpAndDownText = "跌"
                    self.oilTextColor = .setPriceDown()
                default:
                    break
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func getLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
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
//                        self.activityIndicatorView.isHidden = true
                    }
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
//                    self.pickerContentView.isHidden = true
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    func presentDenineAlert() {
        // 提示可至[設定]中開啟權限
        let alertController = UIAlertController(
            title: "定位權限已關閉",
            message:
            "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            self.getWeatherData(locationLat: self.defaultLocation.0, locationLon: self.defaultLocation.1, city: self.defaultCity)
        }
        alertController.addAction(okAction)
        self.present(
            alertController,
            animated: true, completion: nil)
    }
    
    func getWeatherData(locationLat: CLLocationDegrees, locationLon: CLLocationDegrees, city: String) {
        DataManager.shared.getWeather(lat: locationLat, lon: locationLon, city: city) { (model, _) -> (Void) in
            guard let model = model else { return }
            self.weatherModel = model
            
            var oneWeekWx = [String]()
            var oneWeekMaxTemp = [String]()
            var oneWeekMinTemp = [String]()
            
            for weekWx in model.weather.weekWx {
                guard let wx = weekWx.value else { return }
                oneWeekWx.append(wx)
            }
            
            for weekMaxT in model.weather.weekMaxT {
                guard let maxT = weekMaxT.value else { return }
                oneWeekMaxTemp.append(maxT)
            }
            
            for weekMinT in model.weather.weekMinT {
                guard let minT = weekMinT.value else { return }
                oneWeekMinTemp.append(minT)
            }
            
            self.oneWeekWx = oneWeekWx
            self.oneWeekMaxTemp = oneWeekMaxTemp
            self.oneWeekMinTemp = oneWeekMinTemp
            
            if let temp = model.weather.temp,
                let maxTemp = model.weather.maxT,
                let minTemp = model.weather.minT,
                let aqi = model.aqi.aqi,
                let uvi = model.uvi.uvi,
                let pop = model.rain.pop,
                let pm25 = model.aqi.pm25,
                let pm10 = model.aqi.pm10,
                let o3 = model.aqi.o3
            {
                self.cityTemp = "\(city)  \(temp)°"
                self.maxAndMinTemp = "\(maxTemp)° / \(minTemp)°"
                self.aqi = "\(aqi)"
                self.uvi = "\(uvi)"
                self.pop = "\(pop)"
                self.pm25 = pm25
                self.pm10 = pm10
                self.o3 = o3
                
                switch lrint(uvi) {
                case 0 ... 2:
                    self.uviDescription = "紫外線正常"
                case 3 ... 5:
                    self.uviDescription = "紫外線中級"
                default:
                    self.uviDescription = "紫外線過高"
                }
            }
            

            
            
            let descriptionsCount = model.descriptions.count
            let random = Int.random(in: 0 ... descriptionsCount - 1)
            var newShareMessage = "生活小百科提醒： "
            newShareMessage += model.descriptions[random].descriptionDescription ?? ""
            self.shareMessage = newShareMessage
            
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension NewHomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .denied:
            presentDenineAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationLat = locations.last?.coordinate.latitude else { return }
        guard let locationLon = locations.last?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()

        GeocodeManager.shared.geocode(latitude: locationLat, longitude: locationLon) { (placemark, error) in
            guard let city = placemark?.subAdministrativeArea, error == nil else { return }
            self.positionCity = city
            self.getWeatherData(locationLat: locationLat, locationLon: locationLon, city: city)
        }
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
            cell.cityAndTempLabel.text = self.cityTemp
            cell.maxAndMinTempLabel.text = self.maxAndMinTemp
            cell.popLabel.text = "降雨機率 \(self.pop) %"
            cell.uviLabel.text = self.uviDescription
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomeOilCell", for: indexPath) as! NewHomeOilCell
            cell.iconImageView.image = UIImage(named: iconImageNames[indexPath.row])
            cell.oilTitleLabel.text = self.oilTitle
            cell.oilUpAndDownImageView.image = UIImage(named: self.oilUpAndDownImageName)
            cell.oilUpAndDownTextLabel.text = self.oilUpAndDownText
            cell.oilUpAndDownTextLabel.textColor = self.oilTextColor
            cell.oilChangeLabel.text = self.oilChange
            cell.oilChangeLabel.textColor = self.oilTextColor
            cell.oil92Label.text = self.oil92
            cell.oil95Label.text = self.oil95
            cell.oil98Label.text = self.oil98
            cell.oilDieselLabel.text = self.oilDiesel
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomeCollectionViewCell", for: indexPath) as! NewHomeCollectionViewCell
            cell.iconImageView.image = UIImage(named: iconImageNames[indexPath.row])
            cell.titleLabel.text = vcIdMap[indexPath.row]
            return cell
        }
    }
    
    
}
extension NewHomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = vcMap[indexPath.row] else { return }
        
        switch indexPath.row {
        case 0:
            let weatherVC = storyboard?.instantiateViewController(withIdentifier: id) as! WeatherVC
            weatherVC.weatherModel = self.weatherModel
            weatherVC.positionCity = self.positionCity
            weatherVC.oneWeekWx = self.oneWeekWx
            weatherVC.oneWeekMaxTemp = self.oneWeekMaxTemp
            weatherVC.oneWeekMinTemp = self.oneWeekMinTemp
            weatherVC.shareMessage = self.shareMessage
            weatherVC.aqiValue = self.aqi
            weatherVC.uviValue = self.uvi
            weatherVC.popValue = self.pop
            print(self.pop)
            weatherVC.pm25 = self.pm25
            weatherVC.pm10 = self.pm10
            weatherVC.o3 = self.o3
            self.navigationController?.pushViewController(weatherVC, animated: true)
        case 1:
            let oilVC = OilVC.loadFromNib()
            oilVC.oilModel = self.oilModel
            
            self.navigationController?.pushViewController(oilVC, animated: true)
        case 2:
            let postalVC = PostalVC.loadFromNib()
            self.navigationController?.pushViewController(postalVC, animated: true)
//        case 5:
//            if let vc = storyboard?.instantiateViewController(withIdentifier: id) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        default:
            break
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
        return UIEdgeInsets(top: 20 * screenSceleHeight, left: 25 * screenScaleWidth, bottom: 90, right: 25 * screenScaleWidth)
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

extension NewHomeVC {
    func loadBannerView() {
        self.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.bannerView.adUnitID = "ca-app-pub-4291784641323785/5225318746"
        self.bannerView.rootViewController = self
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
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

extension NewHomeVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        addBannerViewToView(bannerView)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}
