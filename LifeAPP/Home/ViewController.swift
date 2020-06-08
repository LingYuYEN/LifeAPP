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
    
    var refreshControl:UIRefreshControl!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var pickerContentView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    
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
    
    var myLocationManager: CLLocationManager!
    var urlOfImageToShare: URL?
    
    var intWeekArr = [Int]()
    //    var chWeekArr = [String]()
    //    var oneWeekMaxTemp = [String]()
    //    var oneWeekMinTemp = [String]()
    var chWeekArr = ["-", "-", "-", "-", "-", "-"]
    var oneWeekMaxTemp = ["-", "-", "-", "-", "-", "-"]
    var oneWeekMinTemp = ["-", "-", "-", "-", "-", "-"]
    var oneWeekWx = ["-", "-", "-", "-", "-", "-"]
    var apiLoadingStatus = [false, false, false, false, false, false]
    
    
    var aqiValue: String?
    var uviValue: String?
    var popValue: String?
    
    var memoHeaderValue: String?
    var memoValue: String?
    var statusValue: String?
    
    var pm25: Int?
    var pm10: Int?
    var o3: Int?
    
    var the3R = "", the24R = ""
    
    
    
    let locationArr = [
        "台北市", "新北市", "基隆市", "宜蘭縣", "桃園市", "新竹縣", "新竹市", "苗栗縣", "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "嘉義市", "台南市", "高雄市", "屏東縣", "花蓮縣", "台東縣", "金門縣", "連江縣", "澎湖縣"
    ]
    let weekArr = ["五", "六", "日", "一", "二", "三"]
    var weatherImageNameArr = ["-", "-", "-", "-", "-", "-"]
    let wxMappingDic = [
        "01" : "wetherIcon1", "02" : "wetherIcon2", "03" : "wetherIcon2", "04" : "wetherIcon4", "05" : "wetherIcon4", "06" : "wetherIcon4", "07" : "wetherIcon4", "08" : "wetherIcon3", "09" : "wetherIcon5", "10" : "wetherIcon5", "11" : "wetherIcon5", "12" : "wetherIcon5", "13" : "wetherIcon5", "14" : "wetherIcon5", "15" : "wetherIcon6", "16" : "wetherIcon6", "17" : "wetherIcon6", "18" : "wetherIcon6", "19" : "wetherIcon3", "20" : "wetherIcon3", "21" : "wetherIcon6", "22" : "wetherIcon6", "23" : "wetherIcon7", "24" : "wetherIcon7", "25" : "wetherIcon7", "26" : "wetherIcon7", "27" : "wetherIcon7", "28" : "wetherIcon7", "29" : "wetherIcon7", "30" : "wetherIcon7", "31" : "wetherIcon7", "32" : "wetherIcon7", "33" : "wetherIcon6", "34" : "wetherIcon6", "35" : "wetherIcon7", "36" : "wetherIcon7", "37" : "wetherIcon7", "38" : "wetherIcon7", "39" : "wetherIcon7", "40" : "wetherIcon7", "41" : "wetherIcon7", "42" : "wetherIcon7"
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
        "彰化縣" : (24.0728834,120.5431642),
        "南投縣" : (23.9026792,120.6883204),
        "雲林縣" : (23.6992302,120.524139),
        "嘉義縣" : (23.4586628,120.2907802),
        "嘉義市" : (23.4812496,120.4514076),
        "台南市" : (23.1499052,120.1006679),
        "高雄市" : (22.6336637,120.2957256),
        "屏東縣" : (22.6830359,120.4857797),
        "花蓮縣" : (23.8736361,121.3990882),
        "台東縣" : (23.8725584,120.9787372),
        "金門縣" : (24.4371905,118.3171542),
        "連江縣" : (26.1579859,119.9496145),
        "澎湖縣" : (24.2777756,119.422305)
    ]
    
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
    
    let cwbLocationNameDic: Dictionary = [
        "台北市" : "F-C0032-009",
        "新北市" : "F-C0032-010",
        "基隆市" : "F-C0032-011",
        "宜蘭縣" : "F-C0032-013",
        "桃園市" : "F-C0032-022",
        "新竹縣" : "F-C0032-023",
        "新竹市" : "F-C0032-024",
        "苗栗縣" : "F-C0032-020",
        "台中市" : "F-C0032-021",
        "彰化縣" : "F-C0032-028",
        "南投縣" : "F-C0032-026",
        "雲林縣" : "F-C0032-029",
        "嘉義縣" : "F-C0032-018",
        "嘉義市" : "F-C0032-019",
        "台南市" : "F-C0032-016",
        "高雄市" : "F-C0032-017",
        "屏東縣" : "F-C0032-025",
        "花蓮縣" : "F-C0032-012",
        "台東縣" : "F-C0032-027",
        "金門縣" : "F-C0032-014",
        "連江縣" : "F-C0032-030",
        "澎湖縣" : "F-C0032-015"
    ]
    
    let baseUrl = DataManager.shared.baseUrl
    let wetherApiKey = DataManager.shared.wetherApiKey
    
    var shareMessage = ""
    var wxDescription = ""
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        self.navigationController?.navigationBar.isHidden = false
        
        setupUI()
        
        // 首次使用 向使用者詢問定位自身位置權限
        //        getAuthorization()
        
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
    func setupUI() {
        chWeekArr = [String]()
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
            chWeekArr.append(todayWeekCh)
        }
        
        dateLabel.text = "\(nowFormatter)"
        
        setWetherView(wetherView: wetherViewFirst, gradientView: stackContentViewFirst)
        setWetherView(wetherView: wetherViewSec, gradientView: stackContentViewSec)
        setWetherView(wetherView: wetherViewThrid, gradientView: stackContentViewThird)
        
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
        //        self.navigationItem.titleView = locationContentView
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
        
        // 經緯度管理
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if #available(iOS 13.0, *) {
            let barAppearance =  UINavigationBarAppearance()
            barAppearance.configureWithTransparentBackground()
            navigationController?.navigationBar.standardAppearance = barAppearance
        }
        
        let nib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        let imageNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.weekendCollectionView.register(nib, forCellWithReuseIdentifier: "TextCollectionViewCell")
        self.weekendCollectionView.register(imageNib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        locationsBtn.addTarget(self, action: #selector(onSelectLocationClick), for: .touchUpInside)
        
        
        
    }
    
    @objc func onSelectLocationClick(_ sender: UIButton) {
        self.locationsBtn.setImage(UIImage(named: "up"), for: .normal)
        pickerViewIsHidden(bool: false)
        
    }
    @IBAction func onMenuPageClick(_ sender: UIBarButtonItem) {
        let menuVC = MenuVC.loadFromNib()
        menuVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.show(menuVC, sender: self)
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
    
    @IBAction func onPickerViewDoneClick(_ sender: UIButton) {
        self.locationsBtn.setImage(UIImage(named: "down"), for: .normal)
        let city = locationArr[pickerView.selectedRow(inComponent: 0)]
        
        guard let coordinate = coordinateMapping[city] else { return }
        print(coordinate)
        DataManager.shared.getWeather(lat: coordinate.0, lon: coordinate.1, city: city) { (model) -> (Void) in
            self.oneWeekMaxTemp = [String]()
            self.oneWeekMinTemp = [String]()
            self.oneWeekWx = [String]()
            self.weatherImageNameArr = [String]()
            guard let model = model else { return }
            
            for weekMaxT in model.weather.weekMaxT {
                self.oneWeekMaxTemp.append(weekMaxT.value)
            }

            for weekMinT in model.weather.weekMinT {
                self.oneWeekMinTemp.append(weekMinT.value)
            }

            for weekWx in model.weather.weekWx {
                guard let wxMapping = self.wxMappingDic[weekWx.value] else { return }
                self.weatherImageNameArr.append(wxMapping)
            }


            self.aqiValue = "\(model.aqi.aqi)"
            self.pm25 = model.aqi.pm25
            self.pm10 = model.aqi.pm10
            self.o3 = model.aqi.o3
            self.uviValue = "\(model.uvi)"

            DispatchQueue.main.async {
                self.locationsBtn.setTitle(city, for: .normal)

                self.wxDescriptionLabel.text = model.weather.wx
                self.locationsBtn.setTitle(city, for: .normal)
                self.nowTempLabel.text = "\(model.weather.temp)"
                self.todayDTXLabel.text = "\(model.weather.maxT)"
                self.todayDTNLabel.text = "\(model.weather.minT)"

                switch model.aqi.aqi {
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

                switch lrint(model.uvi) {
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

                self.popLabel.text = "降雨機率 \(model.rain.pop)％"
                self.popValue = "\(model.rain.pop)"

                switch model.rain.pop {
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
                default:
                    self.popStatusImage.image = UIImage(named: "unsmileIcon")
                    self.popMemoLabel.text = "務必攜帶雨具"
                    self.popDangerImage.isHidden = false
                }

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
        detailVC.value = aqiValue
        
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
        
        //        var memoTextArr = [NSMutableAttributedString]()
        //        var string = NSMutableAttributedString(string: "3 小時累積雨量")
        //        memoTextArr.append(string)
        //        string = NSMutableAttributedString(string: "24 小時累積雨量")
        //        memoTextArr.append(string)
        //        detailVC.memoTextArr = memoTextArr
        
        //        detailVC.cellLabelStatus = [the3R + "  毫米", the24R + "  毫米"]
        //        detailVC.cellLabelIsHidden = true
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
        self.view.bringSubviewToFront(bannerView)
        for constraint in view.constraints {
            if constraint.identifier == "bottom" {
                constraint.constant = bool ? 216 : -50
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
        
        oneWeekMaxTemp = [String]()
        oneWeekMinTemp = [String]()
        oneWeekWx = [String]()
        weatherImageNameArr = [String]()
        
        DispatchQueue.main.async {
            // 套用 url 的各縣市站點名稱
//            guard let newCity = self.locationNameDic[cityStr] else { return }
//            guard let aqiNewCity = self.aqiLocationNameDic[cityStr] else { return }
//            guard let cwbCity = self.cwbLocationNameDic[cityStr] else { return }
            
//            let urlStr = "\(self.baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(self.wetherApiKey)&parameterName=CITY"
//
//            self.getWetherData(urlStr: urlStr, locationName: newCity) { (downloadCompletion) in
//                if downloadCompletion { loadingCount += 1 }
//            }
//
//
//            let aqiUrl = "https://opendata.epa.gov.tw/webapi/Data/AQI/?$skip=0&$top=1000&format=json"
//            self.getAQIData(urlStr: aqiUrl, locationName: aqiNewCity) { (downloadCompletion) in
//                if downloadCompletion { loadingCount += 1 }
//            }
//
//            let uviUrl = "https://opendata.epa.gov.tw/webapi/Data/UV/?$skip=0&$top=1000&format=json"
//            self.getUVIData(urlStr: uviUrl) { (downloadCompletion) in
//                if downloadCompletion { loadingCount += 1 }
//            }
//
//            let popUrl = "\(self.baseUrl)/v1/rest/datastore/F-C0032-001?Authorization=\(self.wetherApiKey)&locationName=\(aqiNewCity)&elementName=PoP"
//            guard let newPopUrl = popUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//            self.getPopData(urlStr: newPopUrl) { (downloadCompletion) in
//                if downloadCompletion { loadingCount += 1 }
//            }
//
//            let oneWeekUrl = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-D0047-091?Authorization=\(self.wetherApiKey)"
//            self.getOneWeekWether(urlStr: oneWeekUrl, locationName: aqiNewCity) { (downloadCompletion) in
//                if downloadCompletion { loadingCount += 1 }
//            }
            
//            // 取得 3H 雨量資訊
//            DataManager.shared.getRain(range: "HOUR_3", locationName: newCity) { (string) -> (Void) in
//                if let the3R = string {
//                    self.the3R = the3R == "-998.00" || the3R == "0.00" ? "0" : the3R
//                }
//            }
//            // 取得 24H 雨量資訊
//            DataManager.shared.getRain(range: "HOUR_24", locationName: newCity) { (string) -> (Void) in
//                if let the24R = string {
//                    self.the24R = the24R == "-998.00" || the24R == "0.00" ? "0" : the24R
//                }
//            }
//
//            // 取得天氣小幫手敘述
//            DataManager.shared.getCWB(locationID: cwbCity) { (string) -> (Void) in
//                guard let string = string else { return }
//                self.shareMessage = string
//                loadingCount += 1
//            }
        }
    }
    
    /// 取得 lat, lon 後開始接 API
//    @objc func locationAddress(latitude: Double, longitude: Double, _ completion: @escaping () -> Void){
//
//        oneWeekMaxTemp = [String]()
//        oneWeekMinTemp = [String]()
//        oneWeekWx = [String]()
//        wetherImageName = [String]()
//
//        DispatchQueue.main.async {
//            /// CLGeocoder地理編碼 經緯度轉換地址位置
//            GeocodeManager.shared.geocode(latitude: latitude, longitude: longitude) { placemark, error in
//                guard let placemark = placemark, error == nil else { return }
//                // you should always update your UI in the main thread
//                DispatchQueue.main.async {
//                    // 定位出來的縣市名稱
//                    guard let city = placemark.subAdministrativeArea else { return }
//                    self.locationsBtn.setTitle(placemark.subAdministrativeArea, for: .normal)
//
//                    // 套用 url 的各縣市站點名稱
//                    guard let newCity = self.locationNameDic[city] else { return }
//                    guard let aqiNewCity = self.aqiLocationNameDic[city] else { return }
//                    guard let cwbCity = self.cwbLocationNameDic[city] else { return }
//
////                    let urlStr = "\(self.baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(self.wetherApiKey)&parameterName=CITY"
////
////                    self.getWetherData(urlStr: urlStr, locationName: newCity) { (finish) in
////                    }
////
////
////                    let aqiUrl = "https://opendata.epa.gov.tw/webapi/Data/AQI/?$skip=0&$top=1000&format=json"
////                    self.getAQIData(urlStr: aqiUrl, locationName: aqiNewCity) { (finish) in
////                        self.apiLoadingStatus[1] = finish
////                    }
////
////                    let uviUrl = "https://opendata.epa.gov.tw/webapi/Data/UV/?$skip=0&$top=1000&format=json"
////                    self.getUVIData(urlStr: uviUrl) { (finish) in
////                    }
////
////                    let popUrl = "\(self.baseUrl)/v1/rest/datastore/F-C0032-001?Authorization=\(self.wetherApiKey)&locationName=\(aqiNewCity)&elementName=PoP"
////                    guard let newPopUrl = popUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
////                    self.getPopData(urlStr: newPopUrl) { (finish) in
////                    }
////
////                    let oneWeekUrl = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-D0047-091?Authorization=\(self.wetherApiKey)"
////                    self.getOneWeekWether(urlStr: oneWeekUrl, locationName: city) { (finish) in
////                    }
//
////                    // 取得 3H 雨量資訊
////                    DataManager.shared.getRain(range: "HOUR_3", locationName: newCity) { (string) -> (Void) in
////                        if let the3R = string {
////                            self.the3R = the3R == "-998.00" || the3R == "0.00" ? "0" : the3R
////                        }
////                    }
////                    // 取得 24H 雨量資訊
////                    DataManager.shared.getRain(range: "HOUR_24", locationName: newCity) { (string) -> (Void) in
////                        if let the24R = string {
////                            self.the24R = the24R == "-998.00" || the24R == "0.00" ? "0" : the24R
////                        }
////                    }
////
////                    // 取得天氣小幫手敘述
////                    DataManager.shared.getCWB(locationID: cwbCity) { (string) -> (Void) in
////                        guard let string = string else { return }
////                        self.shareMessage = string
////                    }
//                }
//
//            }
//        }
//
//
//    }
    
    @objc func loadData(){
        // 這邊我們用一個延遲讀取的方法，來模擬網路延遲效果（延遲3秒）
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            // 停止 refreshControl 動畫
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    
    func setUI() {
        DispatchQueue.main.async {
            self.symbolLabel.isHidden = self.nowTempLabel.text == "-" ? true : false
            self.todayWxMaxImageView.image = UIImage(named: "dayIcon")
            self.todayWxMinImageView.image = UIImage(named: "nightIcon")
        }
    }
    
//    /// 取得天氣資訊
//    func getWetherData(urlStr: String, locationName: String,_ completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: urlStr) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data else { return }
//            do {
//                let wetherModel = try JSONDecoder().decode(OldWetherModel.self, from: data)
//                for location in wetherModel.records.location {
//                    if location.locationName == locationName {
//
//                        for weatherElement in location.weatherElement {
//                            switch weatherElement.elementName {
//                            case .temp:
//                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.nowTempLabel, symbol: false)
//                                self.setUI()
//                            case .dTx:
//                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.todayDTXLabel, symbol: true)
//                            case .dTn:
//                                self.convertTemperature(temperatureStr: weatherElement.elementValue, inputLabel: self.todayDTNLabel, symbol: true)
//                            default:
//                                break
//                            }
//                        }
//                    }
//                }
//                let downloadCompleted = true
//                completion(downloadCompleted)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    /// 取得空氣品質指標
//    @objc func getAQIData(urlStr: String, locationName: String,_ completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: urlStr) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data else { return }
//            do {
//                let aqiModels = try JSONDecoder().decode(AQIModel.self, from: data)
//
//                for aqiModel in aqiModels {
//                    if aqiModel.county == locationName {
//                        DispatchQueue.main.async {
//                            self.aqiValue = aqiModel.aqi
//
//                            self.pm25 = Double(aqiModel.pm25)
//                            self.pm10 = Double(aqiModel.pm10)
//                            self.o3 = Double(aqiModel.o3)
//
//
//
//                            switch aqiModel.status {
//                            case .良好:
//                                self.aqiLabel.text = "空氣品質良好"
//                                self.memoValue = self.aqiLabel.text
//                                self.memoHeaderValue = "好"
//                                self.aqiStatusImage.image = UIImage(named: "smileIcon")
//                                self.statusValue = "smileIcon"
//
//                                self.aqiMemoLabel.text = "正常戶外活動"
//                                self.aqiDangerImage.isHidden = true
//                            //                                self.refreshView.isHidden = true
//                            case .普通:
//                                self.aqiLabel.text = "空氣品質欠佳"
//                                self.memoValue = self.aqiLabel.text
//                                self.memoHeaderValue = "不佳"
//                                self.aqiStatusImage.image = UIImage(named: "normalSmileIcon")
//                                self.statusValue = "normalSmileIcon"
//
//                                self.aqiMemoLabel.text = "記得戴口罩"
//                                self.aqiDangerImage.isHidden = false
//                            //                                self.refreshView.isHidden = true
//                            case .設備維護:
//                                self.aqiLabel.text = "設備維護中..."
//                            //                                self.refreshView.isHidden = true
//                            default:
//                                self.aqiLabel.text = "空氣品質不良"
//                                self.memoValue = self.aqiLabel.text
//                                self.memoHeaderValue = "差"
//                                self.aqiStatusImage.image = UIImage(named: "unsmileIcon")
//                                self.statusValue = "unsmileIcon"
//                                self.aqiMemoLabel.text = "減少戶外活動"
//                                self.aqiDangerImage.isHidden = false
//                                //                                self.refreshView.isHidden = true
//                            }
//
//                        }
//                        break
//                    }
//                }
//                let finish = true
//                completion(finish)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    /// 取得紫外線指標
//    func getUVIData(urlStr: String,_ completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: urlStr) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data else { return }
//            do {
//                let uviModels = try JSONDecoder().decode(UVIModel.self, from: data)
//                for uviModel in uviModels {
//                    DispatchQueue.main.async {
//                        self.uviValue = uviModel.uvi
//                        switch uviModel.publishAgency {
//                        case .中央氣象局:
//                            guard let uviDouble = Double(uviModel.uvi) else { return }
//                            switch lrint(uviDouble) {
//                            case 0 ... 2:
//                                self.uviLabel.text = "紫外線正常"
//                                self.uviStatusImage.image = UIImage(named: "smileIcon")
//                                self.uviMemoLabel.text = "基礎防曬安心外出"
//                                self.uviDangerImage.isHidden = true
//                            case 3 ... 5:
//                                self.uviLabel.text = "紫外線中級"
//                                self.uviStatusImage.image = UIImage(named: "normalSmileIcon")
//                                self.uviMemoLabel.text = "隨時補擦防曬"
//                                self.uviDangerImage.isHidden = true
//                            default:
//                                self.uviLabel.text = "紫外線過高"
//                                self.uviStatusImage.image = UIImage(named: "unsmileIcon")
//                                self.uviMemoLabel.text = "請待在室內或做加倍防曬"
//                                self.uviDangerImage.isHidden = false
//                            }
//                        case .環境保護署:
//                            break
//                        }
//                    }
//                }
//                let finish = true
//                completion(finish)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    /// 取得降雨機率指標
//    func getPopData(urlStr: String,_ completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: urlStr) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data else { return }
//            do {
//                let popModel = try JSONDecoder().decode(POPModel.self, from: data)
//                guard let popElement = popModel.records.location.first?.weatherElement.first?.time.first?.parameter.parameterName else { return }
//
//                DispatchQueue.main.async {
//                    self.popLabel.text = "降雨機率 \(popElement)％"
//                    self.popValue = popElement
//
//                    guard let intPopElement = Int(popElement) else { return }
//                    switch intPopElement {
//                    case 0 ... 10:
//                        self.popStatusImage.image = UIImage(named: "smileIcon")
//                        self.popMemoLabel.text = "是個好天氣"
//                        self.popDangerImage.isHidden = true
//                    case 11 ... 40:
//                        self.popStatusImage.image = UIImage(named: "normalSmileIcon")
//                        self.popMemoLabel.text = "記得攜帶雨具"
//                        self.popDangerImage.isHidden = true
//                    case 41 ... 80:
//                        self.popStatusImage.image = UIImage(named: "normalSmileIcon")
//                        self.popMemoLabel.text = "記得攜帶雨具"
//                        self.popDangerImage.isHidden = false
//                    default:
//                        self.popStatusImage.image = UIImage(named: "unsmileIcon")
//                        self.popMemoLabel.text = "務必攜帶雨具"
//                        self.popDangerImage.isHidden = false
//                    }
//                    let finish = true
//                    completion(finish)
//                }
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    /// 取得一週（六天）天氣
//    func getOneWeekWether(urlStr: String, locationName: String,_ completion: @escaping (Bool) -> Void) {
//
//        oneWeekMaxTemp = [String]()
//        oneWeekMinTemp = [String]()
//        oneWeekWx = [String]()
//        wetherImageName = [String]()
//        let locationNameUrl = "&locationName=\(locationName)"
//        guard let newLocationNameUrl = locationNameUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//
//        guard let url = URL(string: urlStr + newLocationNameUrl) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data else { return }
//            do {
//                let oneWeekWetherModel = try JSONDecoder().decode(OneWeekWetherModel.self, from: data)
//                DispatchQueue.main.async {
//                    guard let weatherElements = oneWeekWetherModel.records.locations.first?.location.first?.weatherElement else { return }
//
//                    for weatherElement in weatherElements {
//                        if weatherElement.elementName == "MaxT" {
//
//                            for index in stride(from: 0, to: 12, by: 2) {
//                                guard let temp = weatherElement.time[index].elementValue.first?.value else { return }
//                                self.oneWeekMaxTemp.append(temp + "°")
//                            }
//                        } else if weatherElement.elementName == "MinT" {
//                            for index in stride(from: 1, to: 13, by: 2) {
//                                guard let temp = weatherElement.time[index].elementValue.first?.value else { return }
//                                self.oneWeekMinTemp.append(temp + "°")
//                            }
//                        }  else if weatherElement.elementName == "Wx" {
//                            self.wxDescriptionLabel.text = weatherElement.time.first?.elementValue.first?.value
//
//                            for index in stride(from: 0, to: 12, by: 2) {
//                                guard let wx = weatherElement.time[index].elementValue.last?.value else { return }
//                                self.oneWeekWx.append(wx)
//                                guard let wxMapping = self.wxMappingDic[wx] else { return }
//                                self.wetherImageName.append(wxMapping)
//                            }
//                        }
//                    }
//                    self.weekendCollectionView.reloadData()
//                    let finish = true
//                    completion(finish)
//                }
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
    
    
    
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
            cell.imageView.image = UIImage(named: weatherImageNameArr[indexPath.row])
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
                
            }
            alertController.addAction(okAction)
            //            self.present(alertController,animated: true, completion: nil)
            self.present(alertController, animated: true) {
                self.selectLocationCity(cityStr: "台北市") {
                    self.locationsBtn.setTitle("台北市", for: .normal)
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
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["7ba6ce8064354f5e9f3ec6453bb021b43150a707"]
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let lat = manager.location?.coordinate.latitude else { return }
        guard let lon = manager.location?.coordinate.longitude else { return }
        manager.stopUpdatingLocation()
        // 取得使用者座標後更新數據
        GeocodeManager.shared.geocode(latitude: lat, longitude: lon) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            guard let city = placemark.subAdministrativeArea else { return }
            
            DataManager.shared.getWeather(lat: lat, lon: lon, city: city) { (model) -> (Void) in
                self.oneWeekMaxTemp = [String]()
                self.oneWeekMinTemp = [String]()
                self.oneWeekWx = [String]()
                self.weatherImageNameArr = [String]()
                guard let model = model else { return }
                
                for weekMaxT in model.weather.weekMaxT {
                    self.oneWeekMaxTemp.append(weekMaxT.value)
                }
                
                for weekMinT in model.weather.weekMinT {
                    self.oneWeekMinTemp.append(weekMinT.value)
                }
                
                for weekWx in model.weather.weekWx {
                    guard let wxMapping = self.wxMappingDic[weekWx.value] else { return }
                    self.weatherImageNameArr.append(wxMapping)
                }
                
                
                self.aqiValue = "\(model.aqi.aqi)"
                self.pm25 = model.aqi.pm25
                self.pm10 = model.aqi.pm10
                self.o3 = model.aqi.o3
                self.uviValue = "\(model.uvi)"
                
                
                DispatchQueue.main.async {
                    self.wxDescriptionLabel.text = model.weather.wx
                    self.locationsBtn.setTitle(city, for: .normal)
                    self.nowTempLabel.text = "\(model.weather.temp)"
                    self.todayDTXLabel.text = "\(model.weather.maxT)"
                    self.todayDTNLabel.text = "\(model.weather.minT)"
                    
                    switch model.aqi.aqi {
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
                    
                    switch lrint(model.uvi) {
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
                    
                    self.popLabel.text = "降雨機率 \(model.rain.pop)％"
                    self.popValue = "\(model.rain.pop)"

                    switch model.rain.pop {
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
                    default:
                        self.popStatusImage.image = UIImage(named: "unsmileIcon")
                        self.popMemoLabel.text = "務必攜帶雨具"
                        self.popDangerImage.isHidden = false
                    }
                    
                    
                    self.weekendCollectionView.reloadData()
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
