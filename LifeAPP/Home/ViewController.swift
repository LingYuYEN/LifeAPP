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
import Network

class ViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var pickerContentView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var contentView: UIView! {
        didSet {
            contentView.frame.size.width = screen.width
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var leftBtnItem: UIBarButtonItem!
    @IBOutlet var shareBtnItem: UIBarButtonItem!
    
    
    
    @IBOutlet var stackContentViewFirst: UIView!
    @IBOutlet var stackContentViewSec: UIView!
    @IBOutlet var stackContentViewThird: UIView!
    
    @IBOutlet var wetherViewFirst: UIView!
    @IBOutlet var wetherViewSec: UIView!
    @IBOutlet var wetherViewThrid: UIView!
    
    @IBOutlet var weekendCollectionView: UICollectionView!
    
    @IBOutlet var wxDescriptionLabel: UILabel!
    @IBOutlet var nowTempLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    
    @IBOutlet var todayWxMaxImageView: UIImageView!
    @IBOutlet var todayDTXLabel: UILabel!
    
    
    @IBOutlet var todayWxMinImageView: UIImageView!
    @IBOutlet var todayDTNLabel: UILabel!
    @IBOutlet var aqiLabel: UILabel!
    @IBOutlet var uviLabel: UILabel!
    @IBOutlet var popLabel: UILabel!
    
    @IBOutlet var aqiStatusImage: UIImageView!
    @IBOutlet var aqiDangerImage: UIImageView!
    @IBOutlet var aqiMemoLabel: UILabel!
    
    
    @IBOutlet var uviStatusImage: UIImageView!
    @IBOutlet var uviDangerImage: UIImageView!
    @IBOutlet var uviMemoLabel: UILabel!
    
    
    @IBOutlet var popStatusImage: UIImageView!
    @IBOutlet var popDangerImage: UIImageView!
    @IBOutlet var popMemoLabel: UILabel!
    
    
    @IBOutlet var locationContentView: UIView!
    @IBOutlet var locationsBtn: UIButton!
    
    @IBOutlet var bannerContentView: UIView!
    
    let monitor = NWPathMonitor()
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial?
    var refreshControl:UIRefreshControl!
    var myLocationManager: CLLocationManager!
    var weatherModel: WeatherModel?
    
    var urlOfImageToShare: URL?
    
    var locationTitleName: String?
    var intWeekArr = [Int]()
    var chWeekArr = ["-", "-", "-", "-", "-", "-"]
    
    var oneWeekWx = ["-", "-", "-", "-", "-", "-"]
    var oneWeekMaxTemp = ["-", "-", "-", "-", "-", "-"]
    var oneWeekMinTemp = ["-", "-", "-", "-", "-", "-"]
    
    var aqiValue: String?
    var uviValue: String?
    var popValue: String?
    
    var memoHeaderValue: String?
    var memoValue: String?
    var statusValue: String?
    
    var pm25: Double?
    var pm10: Double?
    var o3: Double?
    
    var the3R = "", the24R = ""
    var positionCity = ""
    
    
    let locationArr = [
        "台北市", "新北市", "基隆市", "宜蘭縣", "桃園市", "新竹縣", "新竹市", "苗栗縣", "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "嘉義市", "台南市", "高雄市", "屏東縣", "花蓮縣", "台東縣", "金門縣", "連江縣", "澎湖縣"
    ]
    let weekArr = ["五", "六", "日", "一", "二", "三"]
    var weatherImageNameArr = ["-", "-", "-", "-", "-", "-"]
    let wxMappingDic = [
        "01" : "weatherIcon1", "02" : "weatherIcon2", "03" : "weatherIcon2", "04" : "weatherIcon4", "05" : "weatherIcon4", "06" : "weatherIcon4", "07" : "weatherIcon4", "08" : "weatherIcon3", "09" : "weatherIcon5", "10" : "weatherIcon5", "11" : "weatherIcon5", "12" : "weatherIcon5", "13" : "weatherIcon5", "14" : "weatherIcon5", "15" : "weatherIcon6", "16" : "weatherIcon6", "17" : "weatherIcon6", "18" : "weatherIcon6", "19" : "weatherIcon3", "20" : "weatherIcon3", "21" : "weatherIcon6", "22" : "weatherIcon6", "23" : "weatherIcon7", "24" : "weatherIcon7", "25" : "weatherIcon7", "26" : "weatherIcon7", "27" : "weatherIcon7", "28" : "weatherIcon7", "29" : "weatherIcon7", "30" : "weatherIcon7", "31" : "weatherIcon7", "32" : "weatherIcon7", "33" : "weatherIcon6", "34" : "weatherIcon6", "35" : "weatherIcon7", "36" : "weatherIcon7", "37" : "weatherIcon7", "38" : "weatherIcon7", "39" : "weatherIcon7", "40" : "weatherIcon7", "41" : "weatherIcon7", "42" : "weatherIcon7"
    ]
    
    let coordinateMapping = [
        "台北市" : (25.0375417,121.562244),
        "新北市" : (25.0123025,121.4632665),
        "基隆市" : (25.1316201,121.7424584),
        "宜蘭縣" : (24.7307143,121.7609277),
        "桃園市" : (24.9931569,121.2988176),
        "新竹縣" : (24.8268792,121.010715),
        "新竹市" : (24.8268669,120.9778843),
        "苗栗縣" : (24.564855,120.8185503),
        "台中市" : (24.187194,120.6442603),
        "彰化縣" : (22.629944,120.2946353),
        "南投縣" : (23.9026792,120.6883204),
        "雲林縣" : (23.6992302,120.5241337),
        "嘉義縣" : (23.4586628,120.2907802),
        "嘉義市" : (23.4812496,120.4514076),
        "台南市" : (23.1499052,120.1006679),
        "高雄市" : (22.6336637,120.2957256),
        "屏東縣" : (22.6830359,120.4857797),
        "花蓮縣" : (23.8736361,121.3990882),
        "台東縣" : (22.7556232,121.148087),
        "金門縣" : (24.4371905,118.3171542),
        "連江縣" : (26.1579859,119.9496145),
        "澎湖縣" : (23.827306,119.3869569)
    ]
    
    @IBOutlet var naviBar: UINavigationBar!
    @IBOutlet var naviItem: UINavigationItem!
    
    
    var shareMessage = ""
    var wxDescription = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
        naviBar.setBackgroundImage(image, for: .default)
        naviBar.shadowImage = image
        
        // 必須將 locationsBtn 指向 titleView 才可使用
        self.naviItem.titleView = locationsBtn

        self.navigationController?.navigationBar.isHidden = true
        
        
        setupUI()
        
        
        view.addSubview(pickerContentView)
        pickerContentView.translatesAutoresizingMaskIntoConstraints = false
        pickerContentView.heightAnchor.constraint(equalToConstant: 216).isActive = true
        pickerContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pickerContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        let pickerBottomAnchor = pickerContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 266)
        pickerBottomAnchor.identifier = "bottom"
        pickerBottomAnchor.isActive = true
        super.viewWillAppear(animated)
    }
    func setupUI() {
        self.locationsBtn.setTitle(self.locationTitleName, for: .normal)
        
        chWeekArr = [String]()
        var newChWeekArr = [String]()
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
        dateFormatter.dateFormat = "M / dd    (   \(chineseWeek)   )    hh : mm" // 格式化顯示型態
        let nowFormatter = dateFormatter.string(from: now)  // 將現在時間格式化
        
        while intWeekArr.count < 6 {
            intWeek += 1
            if intWeek > 7 {
                intWeek = 1
            }
            intWeekArr.append(intWeek)
            guard let todayWeekCh = intToStrDic[intWeek] else { return }
            newChWeekArr.append(todayWeekCh)
        }
        self.chWeekArr = newChWeekArr
        dateLabel.text = "\(nowFormatter)"
        
        
        setWetherView(wetherView: wetherViewFirst, gradientView: stackContentViewFirst)
        setWetherView(wetherView: wetherViewSec, gradientView: stackContentViewSec)
        setWetherView(wetherView: wetherViewThrid, gradientView: stackContentViewThird)
        
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
                        self.activityIndicatorView.isHidden = true
                    }
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                    //                    self.pickerContentView.isHidden = true
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        activityIndicatorView.layer.cornerRadius = 8 * screenScaleWidth
        
        
        
        
//        self.navigationItem.titleView = locationsBtn
        //        self.navigationItem.titleView = locationContentView
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉回到定位區域", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7)])
        
        self.scrollView.refreshControl = refreshControl
        
        isConnect()
        
        let nib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        let imageNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.weekendCollectionView.register(nib, forCellWithReuseIdentifier: "TextCollectionViewCell")
        self.weekendCollectionView.register(imageNib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        locationsBtn.addTarget(self, action: #selector(onSelectLocationClick), for: .touchUpInside)
        pickerView.setValue(UIColor.black, forKey: "textColor")
        
        loadBannerView()
        
        loadDefaultData()
    }
    
    func loadDefaultData() {
        guard let model = self.weatherModel else { return }
        guard let temp = model.weather.temp else { return }
        guard let maxT = model.weather.maxT else { return }
        guard let minT = model.weather.minT else { return }
        guard let aqi = model.aqi.aqi else { return }
        guard let uvi = model.uvi.uvi else { return }
        guard let pop = model.rain.pop else { return }
        
        self.locationsBtn.setTitle(self.positionCity, for: .normal)
        self.locationsBtn.setImage(UIImage(named: "down"), for: .normal)
        self.wxDescriptionLabel.text = model.weather.wxDescription
        self.nowTempLabel.text = "\(temp)"
        self.symbolLabel.isHidden = self.nowTempLabel.text == "" ? true : false
        self.todayDTXLabel.text = "\(maxT)°"
        self.todayDTNLabel.text = "\(minT)°"
        self.popLabel.text = "降雨機率 \(pop)％"
        
        switch lrint(aqi) {
        case 0 ... 50:
            self.aqiLabel.text = "空氣品質良好"
            self.memoValue = self.aqiLabel.text
            self.memoHeaderValue = "好"
            self.aqiStatusImage.image = UIImage(named: "smileIcon")
            self.statusValue = "smileIcon"
            self.aqiMemoLabel.text = "正常戶外活動"
            self.aqiDangerImage.isHidden = true
        case 51 ... 100:
            self.aqiLabel.text = "空氣品質欠佳"
            self.memoValue = self.aqiLabel.text
            self.memoHeaderValue = "不佳"
            self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
            self.statusValue = "normalSmileIcon"
            
            self.aqiMemoLabel.text = "記得戴口罩"
            self.aqiDangerImage.isHidden = false
        default:
            self.aqiLabel.text = "空氣品質不良"
            self.memoValue = self.aqiLabel.text
            self.memoHeaderValue = "差"
            self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
            self.statusValue = "unsmileIcon"
            self.aqiMemoLabel.text = "減少戶外活動"
            self.aqiDangerImage.isHidden = false
        }
        
        switch lrint(uvi) {
        case 0 ... 2:
            self.uviLabel.text = "紫外線正常"
            self.uviStatusImage.image = UIImage(named: "smileIcon")
            self.uviMemoLabel.text = "基礎防曬安心外出"
            self.uviDangerImage.isHidden = true
        case 3 ... 5:
            self.uviLabel.text = "紫外線中級"
            self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
            self.uviMemoLabel.text = "隨時補擦防曬"
            self.uviDangerImage.isHidden = true
        default:
            self.uviLabel.text = "紫外線過高"
            self.uviStatusImage.image = UIImage(named: "unsmileIcon")
            self.uviMemoLabel.text = "請待在室內或做加倍防曬"
            self.uviDangerImage.isHidden = false
        }
        
        switch model.rain.pop ?? -99 {
        case 0 ... 10:
            self.popStatusImage.image = UIImage(named: "smileIcon")
            self.popMemoLabel.text = "是個好天氣"
            self.popDangerImage.isHidden = true
        case 11 ... 40:
            self.popStatusImage.image = UIImage(named: "normalSmileIcon")
            self.popMemoLabel.text = "記得攜帶雨具"
            self.popDangerImage.isHidden = true
        case 41 ... 80:
            self.popStatusImage.image = UIImage(named: "normalSmileIcon")
            self.popMemoLabel.text = "記得攜帶雨具"
            self.popDangerImage.isHidden = false
        case 81 ... 100:
            self.popStatusImage.image = UIImage(named: "unsmileIcon")
            self.popMemoLabel.text = "務必攜帶雨具"
            self.popDangerImage.isHidden = false
        default:
            self.popStatusImage.image = UIImage(named: "unsmileIcon")
            self.popMemoLabel.text = "測站維護中..."
            self.popDangerImage.isHidden = false
        }
        
    }
    
    func loadBannerView() {
        self.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.bannerView.adUnitID = "ca-app-pub-4291784641323785/5225318746"
        self.bannerView.rootViewController = self
        
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    @objc func onSelectLocationClick(_ sender: UIButton) {
        
        self.locationsBtn.setImage(UIImage(named: "up"), for: .normal)
        pickerViewIsHidden(bool: false)
        
    }
    @IBAction func onleftButtonItemClick(_ sender: UIBarButtonItem) {
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
    
    @IBAction func onPickerViewDoneClick(_ sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.isHidden = false
        self.locationsBtn.setImage(UIImage(named: "down"), for: .normal)
        let city = locationArr[pickerView.selectedRow(inComponent: 0)]
        
        guard let coordinate = coordinateMapping[city] else { return }
        
        DataManager.shared.getWeather(lat: coordinate.0, lon: coordinate.1, city: city) { (model, apiStatus) -> (Void) in
            
            var newOneWeekMaxTemp = [String]()
            var newOneWeekMinTemp = [String]()
            var newWeatherImageNameArr = [String]()
            var newShareMessage = String()
            
            if let apiStatus = apiStatus {
                if apiStatus {
                    print("請求失敗")
                    self.apiErrorAlert()
                }
            }
            guard let model = model else { return }
            
            
            let descriptionsCount = model.descriptions.count
            let random = Int.random(in: 0 ... descriptionsCount - 1)
            newShareMessage = "生活小百科提醒： "
            newShareMessage += model.descriptions[random].descriptionDescription ?? ""
            self.shareMessage = newShareMessage
            
            
            for weekMaxT in model.weather.weekMaxT {
                newOneWeekMaxTemp.append(weekMaxT.value ?? "NA")
            }
            
            for weekMinT in model.weather.weekMinT {
                newOneWeekMinTemp.append(weekMinT.value ?? "NA")
            }
            
            for weekWx in model.weather.weekWx {
                guard let wxMapping = self.wxMappingDic[weekWx.value ?? "NA"] else { return }
                newWeatherImageNameArr.append(wxMapping)
            }
            
            self.oneWeekMaxTemp = newOneWeekMaxTemp
            self.oneWeekMinTemp = newOneWeekMinTemp
            self.weatherImageNameArr = newWeatherImageNameArr
            
            if let aqi = model.aqi.aqi, let pm25 = model.aqi.pm25, let pm10 = model.aqi.pm10, let o3 = model.aqi.o3, let uvi = model.uvi.uvi {
                self.aqiValue = "\(lrint(aqi))"
                self.pm25 = pm25
                self.pm10 = pm10
                self.o3 = o3
                self.uviValue = "\(uvi)"
            }
            
            
            DispatchQueue.main.async {
                self.locationsBtn.setTitle(city, for: .normal)
                self.wxDescriptionLabel.text = model.weather.wxDescription
                
                let temp = model.weather.temp ?? -99
                let maxT = model.weather.maxT ?? -99
                let minT = model.weather.minT ?? -99
                self.nowTempLabel.text = temp == -99 ? "NA" : "\(temp)"
                self.todayDTXLabel.text = maxT == -99 ? "NA" : "\(maxT)°"
                self.todayDTNLabel.text = minT == -99 ? "NA" : "\(minT)°"
                self.symbolLabel.isHidden = self.nowTempLabel.text == "" ? true : false
                
                guard let aqi = model.aqi.aqi else { return }
                switch lrint(aqi) {
                case 0 ... 50:
                    self.aqiLabel.text = "空氣品質良好"
                    self.memoValue = self.aqiLabel.text
                    self.memoHeaderValue = "好"
                    self.aqiStatusImage.image = UIImage(named: "smileIcon")
                    self.statusValue = "smileIcon"
                    self.aqiMemoLabel.text = "正常戶外活動"
                    self.aqiDangerImage.isHidden = true
                case 51 ... 100:
                    self.aqiLabel.text = "空氣品質欠佳"
                    self.memoValue = self.aqiLabel.text
                    self.memoHeaderValue = "不佳"
                    self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
                    self.statusValue = "normalSmileIcon"
                    
                    self.aqiMemoLabel.text = "記得戴口罩"
                    self.aqiDangerImage.isHidden = false
                default:
                    self.aqiLabel.text = "空氣品質不良"
                    self.memoValue = self.aqiLabel.text
                    self.memoHeaderValue = "差"
                    self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
                    self.statusValue = "unsmileIcon"
                    self.aqiMemoLabel.text = "減少戶外活動"
                    self.aqiDangerImage.isHidden = false
                }
                
                guard let uvi = model.uvi.uvi else { return }
                switch lrint(uvi) {
                case 0 ... 2:
                    self.uviLabel.text = "紫外線正常"
                    self.uviStatusImage.image = UIImage(named: "smileIcon")
                    self.uviMemoLabel.text = "基礎防曬安心外出"
                    self.uviDangerImage.isHidden = true
                case 3 ... 5:
                    self.uviLabel.text = "紫外線中級"
                    self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
                    self.uviMemoLabel.text = "隨時補擦防曬"
                    self.uviDangerImage.isHidden = true
                default:
                    self.uviLabel.text = "紫外線過高"
                    self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                    self.uviMemoLabel.text = "請待在室內或做加倍防曬"
                    self.uviDangerImage.isHidden = false
                }
                
                self.popLabel.text = "降雨機率 \(model.rain.pop ?? 0)％"
                self.popValue = "\(model.rain.pop ?? 0)"
                
                switch model.rain.pop ?? -99 {
                case 0 ... 10:
                    self.popStatusImage.image = UIImage(named: "smileIcon")
                    self.popMemoLabel.text = "是個好天氣"
                    self.popDangerImage.isHidden = true
                case 11 ... 40:
                    self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                    self.popMemoLabel.text = "記得攜帶雨具"
                    self.popDangerImage.isHidden = true
                case 41 ... 80:
                    self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                    self.popMemoLabel.text = "記得攜帶雨具"
                    self.popDangerImage.isHidden = false
                case 81 ... 100:
                    self.popStatusImage.image = UIImage(named: "unsmileIcon")
                    self.popMemoLabel.text = "務必攜帶雨具"
                    self.popDangerImage.isHidden = false
                default:
                    self.popStatusImage.image = UIImage(named: "unsmileIcon")
                    self.popMemoLabel.text = "測站維護中..."
                    self.popDangerImage.isHidden = false
                }
                
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                self.weekendCollectionView.reloadData()
            }
        }
        
        pickerViewIsHidden(bool: true)
        
    }
    
    @IBAction func onPickerViewCancelClick(_ sender: UIButton) {
        self.locationsBtn.setImage(UIImage(named: "down"), for: .normal)
        pickerViewIsHidden(bool: true)
    }
    
    @IBAction func onAqiPresentClick(_ sender: UIButton) {
        var memoTextArr = [NSMutableAttributedString]()
        var aqiMemoText = "PM2.5  ( 細懸浮微粒 )"
        let bigFont = UIFont.systemFont(ofSize: 16)
        let smallFont = UIFont.systemFont(ofSize: 10)
        var string = NSMutableAttributedString(string: aqiMemoText, attributes: [.font: bigFont])
        string.setAttributes([.font: smallFont, .baselineOffset: 7], range: NSRange(location: 2, length: 3))
        memoTextArr.append(string)
        
        aqiMemoText = "PM10  ( 懸浮微粒 )"
        string = NSMutableAttributedString(string: aqiMemoText, attributes: [.font: bigFont])
        string.setAttributes([.font: smallFont, .baselineOffset: 7], range: NSRange(location: 2, length: 2))
        memoTextArr.append(string)
        
        aqiMemoText = "O3  ( 臭氧 )"
        string = NSMutableAttributedString(string: aqiMemoText, attributes: [.font: bigFont])
        string.setAttributes([.font: smallFont, .baselineOffset: 7], range: NSRange(location: 1, length: 1))
        memoTextArr.append(string)
        
        var memoLabelArr = [String]()
        
        let detailVC = DetailVC.loadFromNib()
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.titleValue = "空氣品質指標 AQI"
        detailVC.value = self.aqiValue
        
        guard let memoHeaderValue = self.memoHeaderValue, let memoValue = self.memoValue else { return }
        
        detailVC.memoValue = "\(memoHeaderValue) ｜ \(memoValue)"
        detailVC.statusValue = self.statusValue
        
        detailVC.memoTextArr = memoTextArr
        guard let pm25 = self.pm25, let pm10 = self.pm10, let o3 = self.o3 else { return }
        memoLabelArr = [pm25 > 35 ? "不健康" : "健康",
                        pm10 > 154 ? "不健康" : "健康",
                        o3 > 250 ? "不健康" : "健康"]
        detailVC.cellLabelStatus = memoLabelArr
        
        detailVC.publishTimeValue = "更新時間：\(String(describing: getNowFormatter()))"
        self.present(detailVC, animated: false, completion: nil)
    }
    
    @IBAction func onUviPresentClick(_ sender: UIButton) {
        let detailVC = DetailVC.loadFromNib()
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.titleValue = "紫外線指標 UVI"
        detailVC.value = uviValue
        guard let uviValue = uviValue else { return }
        guard let uviDouble = Double(uviValue) else { return }
        let uvi = lrint(uviDouble)
        switch uvi {
        case 0 ... 2:
            detailVC.memoValue = "正常 ｜ 基礎防曬安心外出"
            detailVC.statusValue = "smileIcon"
        case 3 ... 5:
            detailVC.memoValue = "中級 ｜ 隨時補擦防曬"
            detailVC.statusValue = "normalSmileIcon"
        default:
            detailVC.memoValue = "過高 ｜ 請待在室內或做加倍防曬"
            detailVC.statusValue = "unsmileIcon"
        }
        
        
        detailVC.publishTimeValue = "更新時間：\(String(describing: getNowFormatter()))"
        self.present(detailVC, animated: false, completion: nil)
    }
    
    @IBAction func onPopPresentClick(_ sender: UIButton) {
        let detailVC = DetailVC.loadFromNib()
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.titleValue = "降雨機率"
        guard let popValue = popValue else { return }
        detailVC.value = "\(popValue) %"
        
        guard let popDouble = Double(popValue) else { return }
        let pop = lrint(popDouble)
        switch pop {
        case 0 ... 10:
            detailVC.memoValue = "是個好天氣"
            detailVC.statusValue = "smileIcon"
        case 11 ... 80:
            detailVC.memoValue = "記得攜帶雨具"
            detailVC.statusValue = "normalSmileIcon"
        default:
            detailVC.memoValue = "務必攜帶雨具"
            detailVC.statusValue = "unsmileIcon"
        }
        
        detailVC.publishTimeValue = "更新時間：\(String(describing: getNowFormatter()))"
        
        self.present(detailVC, animated: false, completion: nil)
    }
    
    func getNowFormatter () -> String {
        let now = Date()
        let dateFormatter = DateFormatter()     // 建立日期格式化器
        dateFormatter.locale = Locale.current   // 格式化為當地時間
        dateFormatter.dateFormat = "yyyy / MM / dd      hh : mm" // 格式化顯示型態
        let nowFormatter = dateFormatter.string(from: now)  // 將現在時間格式化
        return nowFormatter
    }
    
    func pickerViewIsHidden(bool: Bool) {
        let isHidden = bool
        for constraint in view.constraints {
            if constraint.identifier == "bottom" {
                constraint.constant = bool ? 216 : -50
                break
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        switch isHidden {
        case true:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.pickerContentView.isHidden = isHidden
            }
        case false:
            self.pickerContentView.isHidden = isHidden
        }
    }
    
    @objc func loadData(){
        
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)

            let okAction = UIAlertAction(title: "確認", style: .default) { _ in
                DataManager.shared.getWeather(lat: 25.0375417, lon: 121.562244, city: "台北市") { (model, apiStatus) -> (Void) in

                    var newOneWeekMaxTemp = [String]()
                    var newOneWeekMinTemp = [String]()
                    var newOneWeekWx = [String]()
                    var newShareMessage = String()

                    if let apiStatus = apiStatus {
                        if apiStatus {
                            print("請求失敗")
                            self.apiErrorAlert()
                        }
                    }
                    guard let model = model else { return }

                    let descriptionsCount = model.descriptions.count
                    let random = Int.random(in: 0 ... descriptionsCount - 1)
                    newShareMessage = "生活小百科提醒： "
                    newShareMessage += model.descriptions[random].descriptionDescription ?? ""
                    self.shareMessage = newShareMessage

                    for weekWx in model.weather.weekWx {
                        
                        guard let wx = weekWx.value else { return }
                        newOneWeekWx.append(wx)
                    }
                    
                    for weekMaxT in model.weather.weekMaxT {
                        newOneWeekMaxTemp.append(weekMaxT.value ?? "NA")
                    }

                    for weekMinT in model.weather.weekMinT {
                        newOneWeekMinTemp.append(weekMinT.value ?? "NA")
                    }

                    self.oneWeekMaxTemp = newOneWeekMaxTemp
                    self.oneWeekMinTemp = newOneWeekMinTemp
                    self.oneWeekWx = newOneWeekWx

                    if let aqi = model.aqi.aqi, let pm25 = model.aqi.pm25, let pm10 = model.aqi.pm10, let o3 = model.aqi.o3, let uvi = model.uvi.uvi {
                        self.aqiValue = "\(lrint(aqi))"
                        self.pm25 = pm25
                        self.pm10 = pm10
                        self.o3 = o3
                        self.uviValue = "\(uvi)"
                    }

                    DispatchQueue.main.async {
                        self.locationsBtn.setTitle("台北市", for: .normal)
                        self.wxDescriptionLabel.text = model.weather.wxDescription

                        let temp = model.weather.temp ?? -99
                        let maxT = model.weather.maxT ?? -99
                        let minT = model.weather.minT ?? -99
                        self.nowTempLabel.text = temp == -99 ? "NA" : "\(temp)"
                        self.todayDTXLabel.text = maxT == -99 ? "NA" : "\(maxT)°"
                        self.todayDTNLabel.text = minT == -99 ? "NA" : "\(minT)°"
                        self.symbolLabel.isHidden = self.nowTempLabel.text == "" ? true : false

                        guard let aqi = model.aqi.aqi else { return }
                        switch lrint(aqi) {
                        case 0 ... 50:
                            self.aqiLabel.text = "空氣品質良好"
                            self.memoValue = self.aqiLabel.text
                            self.memoHeaderValue = "好"
                            self.aqiStatusImage.image = UIImage(named: "smileIcon")
                            self.statusValue = "smileIcon"
                            self.aqiMemoLabel.text = "正常戶外活動"
                            self.aqiDangerImage.isHidden = true
                        case 51 ... 100:
                            self.aqiLabel.text = "空氣品質欠佳"
                            self.memoValue = self.aqiLabel.text
                            self.memoHeaderValue = "不佳"
                            self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.statusValue = "normalSmileIcon"

                            self.aqiMemoLabel.text = "記得戴口罩"
                            self.aqiDangerImage.isHidden = false
                        default:
                            self.aqiLabel.text = "空氣品質不良"
                            self.memoValue = self.aqiLabel.text
                            self.memoHeaderValue = "差"
                            self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
                            self.statusValue = "unsmileIcon"
                            self.aqiMemoLabel.text = "減少戶外活動"
                            self.aqiDangerImage.isHidden = false
                        }

                        guard let uvi = model.uvi.uvi else { return }
                        switch lrint(uvi) {
                        case 0 ... 2:
                            self.uviLabel.text = "紫外線正常"
                            self.uviStatusImage.image = UIImage(named: "smileIcon")
                            self.uviMemoLabel.text = "基礎防曬安心外出"
                            self.uviDangerImage.isHidden = true
                        case 3 ... 5:
                            self.uviLabel.text = "紫外線中級"
                            self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.uviMemoLabel.text = "隨時補擦防曬"
                            self.uviDangerImage.isHidden = true
                        default:
                            self.uviLabel.text = "紫外線過高"
                            self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                            self.uviMemoLabel.text = "請待在室內或做加倍防曬"
                            self.uviDangerImage.isHidden = false
                        }

                        self.popLabel.text = "降雨機率 \(model.rain.pop ?? 0)％"
                        self.popValue = "\(model.rain.pop ?? 0)"

                        switch model.rain.pop ?? -99 {
                        case 0 ... 10:
                            self.popStatusImage.image = UIImage(named: "smileIcon")
                            self.popMemoLabel.text = "是個好天氣"
                            self.popDangerImage.isHidden = true
                        case 11 ... 40:
                            self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.popMemoLabel.text = "記得攜帶雨具"
                            self.popDangerImage.isHidden = true
                        case 41 ... 80:
                            self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.popMemoLabel.text = "記得攜帶雨具"
                            self.popDangerImage.isHidden = false
                        case 81 ... 100:
                            self.popStatusImage.image = UIImage(named: "unsmileIcon")
                            self.popMemoLabel.text = "務必攜帶雨具"
                            self.popDangerImage.isHidden = false
                        default:
                            self.popStatusImage.image = UIImage(named: "unsmileIcon")
                            self.popMemoLabel.text = "測站維護中..."
                            self.popDangerImage.isHidden = false
                        }

                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                        self.weekendCollectionView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        case .authorizedWhenInUse:
            // 進入 delegate
            self.myLocationManager.delegate = self
            self.myLocationManager.startUpdatingLocation()
        default:
            break

        }
    }
    
    
    
    func setUI() {
        DispatchQueue.main.async {
            self.symbolLabel.isHidden = self.nowTempLabel.text == "" ? true : false
            self.todayWxMaxImageView.image = UIImage(named: "dayIcon")
            self.todayWxMinImageView.image = UIImage(named: "nightIcon")
        }
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
        
        gradientLayer.colors = [
            UIColor.set(red: 22, green: 0, blue: 154).withAlphaComponent(0.78).cgColor,
            UIColor.set(red: 2, green: 5, blue: 113).withAlphaComponent(0.78).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
        
        wetherView.layer.cornerRadius = 8
        wetherView.layer.borderWidth = 1
        wetherView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        wetherView.layer.applySketchShadow(color: .set(red: 255, green: 0, blue: 0), alpha: 0.19, x: 1.3, y: 1.3, blur: 3.7, spread: 0)
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
    
    /// 加入插頁式廣告頁面
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4291784641323785/8037037113")
        guard let interstitial = interstitial else { return nil }
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        return interstitial
    }
    
    /// 錯誤請求 Alert
    func apiErrorAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "載入失敗", message: "天氣資訊更新中，請稍後再試，或請查詢其他區域", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "完成", style: .cancel) { _ in
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    
}

extension ViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        bannerContentView.isHidden = false
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
        return chWeekArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell", for: indexPath) as! TextCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel.text = chWeekArr[indexPath.row]
            cell.textLabel.font = UIFont(name: "PingFangTC-Regular", size: 17)
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            if let wxImageName = wxMappingDic[oneWeekWx[indexPath.row]] {
                cell.imageView.image = UIImage(named: wxImageName)
            }
            
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
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為垂直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 * screenSceleHeight
    }
    
    /// 滑動方向為「垂直」的話即「左右」的間距(預設為垂直)
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 取得定位服務授權
            manager.requestWhenInUseAuthorization()
            // 開始定位自身位置
            manager.startUpdatingLocation()
        case .denied:
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "確認", style: .default) { _ in
                self.refreshControl.endRefreshing()
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true) {
                DataManager.shared.getWeather(lat: 25.0375417, lon: 121.562244, city: "台北市") { (model, apiStatus) -> (Void) in
                    self.oneWeekMaxTemp = [String]()
                    self.oneWeekMinTemp = [String]()
                    self.oneWeekWx = [String]()
                    self.weatherImageNameArr = [String]()
                    if let apiStatus = apiStatus {
                        if apiStatus {
                            self.apiErrorAlert()
                        }
                    }
                    guard let model = model else { return }
                    
                    let descriptionsCount = model.descriptions.count
                    let random = Int.random(in: 0 ... descriptionsCount - 1)
                    self.shareMessage = model.descriptions[random].descriptionDescription ?? ""
                    
                    for weekMaxT in model.weather.weekMaxT {
                        self.oneWeekMaxTemp.append(weekMaxT.value ?? "NA")
                    }

                    for weekMinT in model.weather.weekMinT {
                        self.oneWeekMinTemp.append(weekMinT.value ?? "NA")
                    }

                    for weekWx in model.weather.weekWx {
                        guard let wxMapping = self.wxMappingDic[weekWx.value ?? "01"] else { return }
                        self.weatherImageNameArr.append(wxMapping)
                    }


                    
                    
                    if let aqi = model.aqi.aqi, let pm25 = model.aqi.pm25, let pm10 = model.aqi.pm10, let o3 = model.aqi.o3, let uvi = model.uvi.uvi {
                        self.aqiValue = "\(lrint(aqi))"
                        self.pm25 = pm25
                        self.pm10 = pm10
                        self.o3 = o3
                        self.uviValue = "\(uvi)"
                    }
                    

                    DispatchQueue.main.async {
                        self.locationsBtn.setTitle("台北市", for: .normal)
                        self.wxDescriptionLabel.text = model.weather.wxDescription
                        
                        let temp = model.weather.temp ?? -99
                        let maxT = model.weather.maxT ?? -99
                        let minT = model.weather.minT ?? -99
                        self.nowTempLabel.text = temp == -99 ? "NA" : "\(temp)"
                        self.todayDTXLabel.text = maxT == -99 ? "NA" : "\(maxT)°"
                        self.todayDTNLabel.text = minT == -99 ? "NA" : "\(minT)°"
                        self.symbolLabel.isHidden = self.nowTempLabel.text == "" ? true : false

                        guard let aqi = model.aqi.aqi else { return }
                        switch lrint(aqi) {
                        case 0 ... 50:
                            self.aqiLabel.text = "空氣品質良好"
                            self.memoValue = self.aqiLabel.text
                            self.memoHeaderValue = "好"
                            self.aqiStatusImage.image = UIImage(named: "smileIcon")
                            self.statusValue = "smileIcon"
                            self.aqiMemoLabel.text = "正常戶外活動"
                            self.aqiDangerImage.isHidden = true
                        case 51 ... 100:
                            self.aqiLabel.text = "空氣品質欠佳"
                            self.memoValue = self.aqiLabel.text
                            self.memoHeaderValue = "不佳"
                            self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.statusValue = "normalSmileIcon"

                            self.aqiMemoLabel.text = "記得戴口罩"
                            self.aqiDangerImage.isHidden = false
                        default:
                            self.aqiLabel.text = "空氣品質不良"
                            self.memoValue = self.aqiLabel.text
                            self.memoHeaderValue = "差"
                            self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
                            self.statusValue = "unsmileIcon"
                            self.aqiMemoLabel.text = "減少戶外活動"
                            self.aqiDangerImage.isHidden = false
                        }

                        guard let uvi = model.uvi.uvi else { return }
                        switch lrint(uvi) {
                        case 0 ... 2:
                            self.uviLabel.text = "紫外線正常"
                            self.uviStatusImage.image = UIImage(named: "smileIcon")
                            self.uviMemoLabel.text = "基礎防曬安心外出"
                            self.uviDangerImage.isHidden = true
                        case 3 ... 5:
                            self.uviLabel.text = "紫外線中級"
                            self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.uviMemoLabel.text = "隨時補擦防曬"
                            self.uviDangerImage.isHidden = true
                        default:
                            self.uviLabel.text = "紫外線過高"
                            self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                            self.uviMemoLabel.text = "請待在室內或做加倍防曬"
                            self.uviDangerImage.isHidden = false
                        }

                        self.popLabel.text = "降雨機率 \(model.rain.pop ?? 0)％"
                        self.popValue = "\(model.rain.pop ?? 0)"

                        switch model.rain.pop ?? -99 {
                        case 0 ... 10:
                            self.popStatusImage.image = UIImage(named: "smileIcon")
                            self.popMemoLabel.text = "是個好天氣"
                            self.popDangerImage.isHidden = true
                        case 11 ... 40:
                            self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.popMemoLabel.text = "記得攜帶雨具"
                            self.popDangerImage.isHidden = true
                        case 41 ... 80:
                            self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                            self.popMemoLabel.text = "記得攜帶雨具"
                            self.popDangerImage.isHidden = false
                        case 81 ... 100:
                            self.popStatusImage.image = UIImage(named: "unsmileIcon")
                            self.popMemoLabel.text = "務必攜帶雨具"
                            self.popDangerImage.isHidden = false
                        default:
                            self.popStatusImage.image = UIImage(named: "unsmileIcon")
                            self.popMemoLabel.text = "測站維護中..."
                            self.popDangerImage.isHidden = false
                        }

                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                        self.weekendCollectionView.reloadData()
//                        self.refreshControl.endRefreshing()
                    }
                    
                }
            }
            
        case .authorizedWhenInUse:
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        default:
            break
        }
        
        self.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.bannerView.adUnitID = "ca-app-pub-4291784641323785/5225318746"
        self.bannerView.rootViewController = self
        
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let lat = locations.first?.coordinate.latitude else { return }
        guard let lon = locations.first?.coordinate.longitude else { return }
        
        myLocationManager.stopUpdatingLocation()
        
        // 取得使用者座標後更新數據
        GeocodeManager.shared.geocode(latitude: lat, longitude: lon) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            guard let city = placemark.subAdministrativeArea else { return }
            
            DataManager.shared.getWeather(lat: lat, lon: lon, city: city) { (model, apiStatus) -> (Void) in
                
                var newOneWeekMaxTemp = [String]()
                var newOneWeekMinTemp = [String]()
                var newWeatherImageNameArr = [String]()
                var newShareMessage = String()
                
                if let apiStatus = apiStatus {
                    if apiStatus {
                        self.apiErrorAlert()
                    }
                }
                guard let model = model else { return }
                
                let descriptionsCount = model.descriptions.count
                let random = Int.random(in: 0 ... descriptionsCount - 1)
                newShareMessage = "生活小百科提醒： "
                newShareMessage += model.descriptions[random].descriptionDescription ?? ""
                self.shareMessage = newShareMessage
                
                for weekMaxT in model.weather.weekMaxT {
                    newOneWeekMaxTemp.append(weekMaxT.value ?? "NA")
                }
                
                for weekMinT in model.weather.weekMinT {
                    newOneWeekMinTemp.append(weekMinT.value ?? "NA")
                }
                
                for weekWx in model.weather.weekWx {
                    guard let wxMapping = self.wxMappingDic[weekWx.value ?? "NA"] else { return }
                    newWeatherImageNameArr.append(wxMapping)
                }
                
                self.oneWeekMaxTemp = newOneWeekMaxTemp
                self.oneWeekMinTemp = newOneWeekMinTemp
                self.weatherImageNameArr = newWeatherImageNameArr
                
                if let aqi = model.aqi.aqi, let pm25 = model.aqi.pm25, let pm10 = model.aqi.pm10, let o3 = model.aqi.o3, let uvi = model.uvi.uvi {
                    self.aqiValue = "\(lrint(aqi))"
                    self.pm25 = pm25
                    self.pm10 = pm10
                    self.o3 = o3
                    self.uviValue = "\(uvi)"
                }
                
                DispatchQueue.main.async {
                    self.locationsBtn.setTitle(city, for: .normal)
                    
                    self.wxDescriptionLabel.text = model.weather.wxDescription
                    
                    let temp = model.weather.temp ?? -99
                    let maxT = model.weather.maxT ?? -99
                    let minT = model.weather.minT ?? -99
                    self.nowTempLabel.text = temp == -99 ? "NA" : "\(temp)"
                    self.todayDTXLabel.text = maxT == -99 ? "NA" : "\(maxT)°"
                    self.todayDTNLabel.text = minT == -99 ? "NA" : "\(minT)°"
                    self.symbolLabel.isHidden = self.nowTempLabel.text == "" ? true : false
                    
                    guard let aqi = model.aqi.aqi else { return }
                    switch lrint(aqi) {
                    case 0 ... 50:
                        self.aqiLabel.text = "空氣品質良好"
                        self.memoValue = self.aqiLabel.text
                        self.memoHeaderValue = "好"
                        self.aqiStatusImage.image = UIImage(named: "smileIcon")
                        self.statusValue = "smileIcon"
                        self.aqiMemoLabel.text = "正常戶外活動"
                        self.aqiDangerImage.isHidden = true
                    case 51 ... 100:
                        self.aqiLabel.text = "空氣品質欠佳"
                        self.memoValue = self.aqiLabel.text
                        self.memoHeaderValue = "不佳"
                        self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
                        self.statusValue = "normalSmileIcon"
                        
                        self.aqiMemoLabel.text = "記得戴口罩"
                        self.aqiDangerImage.isHidden = false
                    default:
                        self.aqiLabel.text = "空氣品質不良"
                        self.memoValue = self.aqiLabel.text
                        self.memoHeaderValue = "差"
                        self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
                        self.statusValue = "unsmileIcon"
                        self.aqiMemoLabel.text = "減少戶外活動"
                        self.aqiDangerImage.isHidden = false
                    }
                    
                    guard let uvi = model.uvi.uvi else { return }
                    switch lrint(uvi) {
                    case 0 ... 2:
                        self.uviLabel.text = "紫外線正常"
                        self.uviStatusImage.image = UIImage(named: "smileIcon")
                        self.uviMemoLabel.text = "基礎防曬安心外出"
                        self.uviDangerImage.isHidden = true
                    case 3 ... 5:
                        self.uviLabel.text = "紫外線中級"
                        self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
                        self.uviMemoLabel.text = "隨時補擦防曬"
                        self.uviDangerImage.isHidden = true
                    default:
                        self.uviLabel.text = "紫外線過高"
                        self.uviStatusImage.image = UIImage(named: "unsmileIcon")
                        self.uviMemoLabel.text = "請待在室內或做加倍防曬"
                        self.uviDangerImage.isHidden = false
                    }
                    
                    
                    self.popLabel.text = "降雨機率 \(model.rain.pop ?? 0)％"
                    self.popValue = "\(model.rain.pop ?? 0)"
                    
                    switch model.rain.pop ?? -99 {
                    case 0 ... 10:
                        self.popStatusImage.image = UIImage(named: "smileIcon")
                        self.popMemoLabel.text = "是個好天氣"
                        self.popDangerImage.isHidden = true
                    case 11 ... 40:
                        self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                        self.popMemoLabel.text = "記得攜帶雨具"
                        self.popDangerImage.isHidden = true
                    case 41 ... 80:
                        self.popStatusImage.image = UIImage(named: "normalSmileIcon")
                        self.popMemoLabel.text = "記得攜帶雨具"
                        self.popDangerImage.isHidden = false
                    case 81 ... 100:
                        self.popStatusImage.image = UIImage(named: "unsmileIcon")
                        self.popMemoLabel.text = "務必攜帶雨具"
                        self.popDangerImage.isHidden = false
                    default:
                        self.popStatusImage.image = UIImage(named: "unsmileIcon")
                        self.popMemoLabel.text = "測站維護中..."
                        self.popDangerImage.isHidden = false
                    }
                    
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                    self.weekendCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                }
            }
        }
    }
    
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

extension ViewController: UIScrollViewDelegate {
    
}
