//
//  PostalVC.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/20.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PostalVC: UIViewController {
    
    
    @IBOutlet var naviBar: UINavigationBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBtnContentView: UIView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var pickerView: PickerView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var pickerViewTop: NSLayoutConstraint!
    
    var cellDefaultTitleArr = ["選擇縣市", "選擇區域", "選擇區域路名段號"]
    var zipFiveArr = [String]()
    var cityArr = [String]()
    var areaArr = [String]()
    var roadArr = [String]()
    var scopeArr = [String]()
    
    var dicArr = [[String : String]]()
    
//    var cityPickerNames = [
//        "X基隆市",
//        "臺北市",
//        "新北市",
//        "桃園市",
//        "新竹市",
//        "新竹縣",
//        "苗栗縣",
//        "臺中市",
//        "彰化縣",
//        "南投縣",
//        "雲林縣",
//        "嘉義市",
//        "嘉義縣",
//        "臺南市",
//        "高雄市",
//        "屏東縣",
//        "臺東縣",
//        "花蓮縣",
//        "宜蘭縣",
//        "澎湖縣",
//        "金門縣",
//        "連江縣"
//    ]
//
//    var areaPickerNames = [
//        "中山區",
//        "中正區",
//        "萬華區",
//        "苓雅區",
//        "前鎮區"
//    ]
//
//    var roadPickerNames = [
//        "中正路",
//        "中華路",
//        "中山路",
//        "中北路",
//        "中東路"
//    ]
    
    var cityPickerNames = [String]()
    
    var areaPickerNames = [String]()
    
    var roadPickerNames = [String]()
    
    var collectionSelectIndex = IndexPath()
    var pickerSelectIndex = Int()
    
    var cityRow = Int()
    var areaRow: Int?
    var roadRow: Int?
    
    var zipCode = String()
    var area = String()
    var road = String()
    var scope = String()
    
    var bannerView: GADBannerView!
    
    var zipFiveModels: [ZipFiveModel]?
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        
        naviBar.setBackgroundImage(image, for: .default)
        naviBar.shadowImage = image
        
        // 取消預設 back icon
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.register(UINib(nibName: "PostalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostalCollectionViewCell")
        tableView.register(UINib(nibName: "PostalTableViewCell", bundle: nil), forCellReuseIdentifier: "PostalTableViewCell")
        tableView.register(UINib(nibName: "PostalTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "PostalTableViewHeaderView")
        
        pickerView.doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        pickerView.cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        pickerView.labels = [String]()
        pickerView.pickerView.dataSource = self
        pickerView.pickerView.delegate = self
        
        
        let models = ZipCodeManager.shared.models
        cityArr = [String]()
        
        // 先取得縣市 pickerView Title
        for model in models {
            cityArr.append(model.city)
        }
        
        self.cityPickerNames = cityArr.removingDuplicates()
        
        
        
        
        setUI()
    }
    

    
    @objc func doneAction() {
        
        areaArr = [String]()
        roadArr = [String]()
        
        switch collectionSelectIndex.row {
        case 0:
            self.cityRow = self.pickerView.pickerView.selectedRow(inComponent: 0)
        case 1:
            self.areaRow = self.pickerView.pickerView.selectedRow(inComponent: 0)
        case 2:
            self.roadRow = self.pickerView.pickerView.selectedRow(inComponent: 0)
        default:
            break
        }
        pickerSelectIndex = self.pickerView.pickerView.selectedRow(inComponent: 0)
        
        self.cellDefaultTitleArr[0] = self.cityPickerNames[self.cityRow]
        
        // 如果縣市已有值，則取得 Area pickerView title
        if self.cityPickerNames.count != 0 {
            let cityModels = ZipCodeManager.shared.search(city: self.cityPickerNames[self.cityRow], area: "", road: "")
            
            for cityModel in cityModels {
                areaArr.append(cityModel.area)
            }
            
            self.areaPickerNames = areaArr.removingDuplicates()
            
            if let areaRow = self.areaRow {
                self.cellDefaultTitleArr[1] = self.areaPickerNames[areaRow]
            } else {
                self.cellDefaultTitleArr[1] = "選擇區域"
            }
            
        }
        
        
        // 如果 Area 已有值，則取得 road pickerView title
        if self.areaPickerNames.count != 0 {
            if let areaRow = self.areaRow {
                let areaModels = ZipCodeManager.shared.search(city: self.cityPickerNames[self.cityRow], area: self.areaPickerNames[areaRow], road: "")
                
                for areaModel in areaModels {
                    roadArr.append(areaModel.road)
                }
            }
            
            
            
            self.roadPickerNames = roadArr.removingDuplicates()
            
            if let roadRow = self.roadRow {
                self.cellDefaultTitleArr[2] = self.roadPickerNames[roadRow]
            } else {
                self.cellDefaultTitleArr[2] = "選擇區域路名段號"
            }
        }
        
        var areaMap = ""
        if self.cellDefaultTitleArr[1] != "選擇區域" {
            areaMap = self.cellDefaultTitleArr[1]
        }
        
        var roadMap = ""
        if self.cellDefaultTitleArr[2] != "選擇區域路名段號" {
            roadMap = self.cellDefaultTitleArr[2]
        }
        
        let dataArr = ZipCodeManager.shared.search(city: self.cellDefaultTitleArr[0], area: areaMap, road: roadMap)
        
        var zipResult = [String]()
        var areaResult = [String]()
        var roadResult = [String]()
        var scopeResult = [String]()
        
        for data in dataArr {
            zipResult.append(data.zip5)
            areaResult.append(data.area)
            roadResult.append(data.road)
            scopeResult.append(data.scope)
        }
        
        self.zipFiveArr = zipResult
        self.areaArr = areaResult
        self.roadArr = roadResult
        self.scopeArr = scopeResult
        
        self.pickerViewIsHidden(bool: true)
        self.collectionView.reloadData()
    }
    
    @objc func cancelAction() {
        self.pickerViewIsHidden(bool: true)
    }
    
    @IBAction func onSearchBtnClick(_ sender: UIButton) {
        if self.cellDefaultTitleArr[0] == "選擇縣市" {
            let postalDetailVC = PostalDetailVC.loadFromNib()
            postalDetailVC.modalPresentationStyle = .overFullScreen
            postalDetailVC.selectMemoText = "請選擇縣市 > 區域"
            self.present(postalDetailVC, animated: false, completion: nil)
        } else if self.cellDefaultTitleArr[1] == "選擇區域" {
            let postalDetailVC = PostalDetailVC.loadFromNib()
            postalDetailVC.modalPresentationStyle = .overFullScreen
            postalDetailVC.selectMemoText = "請選擇區域"
            self.present(postalDetailVC, animated: false, completion: nil)
        } else {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onDismissClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUI() {
        loadBannerView()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        activityIndicatorView.layer.cornerRadius = 8 * screenScaleWidth
        
        gradientView.layer.applySketchShadow(color: .set(red: 13, green: 121, blue: 183), alpha: 1, x: 0, y: 0, blur: 5, spread: 0)
        gradientView.setGradientBorder(
            lineWidth: 1,
            colors: [
                UIColor.set(red: 85, green: 219, blue: 255).withAlphaComponent(0.98),
                UIColor.set(red: 6, green: 168, blue: 255)
            ],
            bounds: CGRect(x: 0, y: 0, width: 131 * screenScaleWidth, height: 39.5 * screenSceleHeight)
        )
        searchBtnContentView.layer.cornerRadius = 8 * screenScaleWidth
    }
    
}

extension PostalVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDefaultTitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostalCollectionViewCell", for: indexPath) as! PostalCollectionViewCell
        
        cell.titleLabel.text = self.cellDefaultTitleArr[indexPath.row]
        return cell
    }
    
    
}

extension PostalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionSelectIndex = indexPath
        switch indexPath.row {
        case 0:
            self.pickerViewIsHidden(bool: false)
            self.pickerView.labels = self.cityPickerNames
        case 1:
            if self.cellDefaultTitleArr[0] == "選擇縣市" {
                let postalDetailVC = PostalDetailVC.loadFromNib()
                postalDetailVC.modalPresentationStyle = .overFullScreen
                postalDetailVC.selectMemoText = "請選擇縣市"
                self.present(postalDetailVC, animated: false, completion: nil)
            } else {
                self.pickerViewIsHidden(bool: false)
                self.pickerView.labels = self.areaPickerNames
            }
        case 2:
            if self.cellDefaultTitleArr[1] == "選擇區域" {
                let postalDetailVC = PostalDetailVC.loadFromNib()
                postalDetailVC.modalPresentationStyle = .overFullScreen
                postalDetailVC.selectMemoText = "請選擇縣市 > 區域"
                self.present(postalDetailVC, animated: false, completion: nil)
            } else {
                self.pickerViewIsHidden(bool: false)
                self.pickerView.labels = self.roadPickerNames
            }
        default:
            break
        }
        
        
    }
}

extension PostalVC: UICollectionViewDelegateFlowLayout {
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20 * screenSceleHeight, left: 25 * screenScaleWidth, bottom: 15 * screenSceleHeight, right: 25 * screenScaleWidth)
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 364 * screenScaleWidth , height: 53 * screenSceleHeight)
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

extension PostalVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipFiveArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostalTableViewCell", for: indexPath) as! PostalTableViewCell
        cell.zipCodeLabel.text = self.zipFiveArr[indexPath.row]
        cell.roadLabel.text = "\(self.areaArr[indexPath.row])  \(self.roadArr[indexPath.row])"
        cell.numberLabel.text = self.scopeArr[indexPath.row]
        return cell
    }
}

extension PostalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48 * screenSceleHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PostalTableViewHeaderView")
        
        return headerView
    }
}

extension PostalVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerView.labels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerView.labels[row]
    }
    
}

extension PostalVC: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//    }
}

extension PostalVC {
    func pickerViewIsHidden(bool: Bool) {
        self.pickerViewTop.constant = bool ? 50 * screenSceleHeight : -257 * screenSceleHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
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

extension PostalVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
//        bannerContentView.isHidden = false
        addBannerViewToView(bannerView)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}
