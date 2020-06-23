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
    
    var zipCode = String()
    var area = String()
    var road = String()
    var scope = String()
    
    var bannerView: GADBannerView!
    
    var zipFiveModel: [ZipFiveModel]?
    
    
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
        
        
        getZipCode(city: "", area: "") { (_) -> (Void) in
            
            DispatchQueue .main .async {
                self.pickerView.labels = self.cityPickerNames
                self.pickerView.pickerView.reloadAllComponents()
            }
        }
        
        setUI()
    }
    
    func getZipCode(city: String = "", area: String = "", road: String = "", completed: @escaping (String?) -> (Void)) {
        activityIndicatorView.isHidden = false
        DataManager.shared.getZipFive { (models, error) -> (Void) in
            guard let models = models else { return }
            self.zipFiveModel = models
            
            var newCityPickerNames = [String]()
            var newAreaPickerNames = [String]()
            var newRoadPickerNames = [String]()
            
            var zipResult = [String]()
            var areaResult = [String]()
            var roadResult = [String]()
            var scopeResult = [String]()
            
//            var results =  [result]()
            
            for model in models {
                newCityPickerNames.append(model.city)
                
                if model.city == city {
                    newAreaPickerNames.append(model.area)
                }
                
                if model.area == area {
                    newRoadPickerNames.append(model.road)
                }
                
                if city == model.city && area == model.area && road == "八德路１段" {
                    
                    zipResult.append(model.zip5)
                    areaResult.append(model.area)
                    roadResult.append(model.road)
                    scopeResult.append(model.scope)
                }
                
                self.zipFiveArr = zipResult
                self.areaArr = areaResult
                self.roadArr = roadResult
                self.scopeArr = scopeResult
            }
            print("print(city, area, road)")
            print(city, area, road)
            
            print("print(self.zipFiveArr, self.areaArr, self.roadArr, self.scopeArr)")
            print(self.zipFiveArr, self.areaArr, self.roadArr, self.scopeArr)
            
            self.cityPickerNames = newCityPickerNames.removingDuplicates()
            self.areaPickerNames = newAreaPickerNames.removingDuplicates()
            self.roadPickerNames = newRoadPickerNames.removingDuplicates()
            
            
            print("=====================")
            print(self.cityPickerNames)
            print(self.areaPickerNames)
            print(self.roadPickerNames)
            print("=====================")
            
            
            
            DispatchQueue.main.async {
                self.activityIndicatorView.isHidden = true
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func doneAction() {
        self.pickerViewIsHidden(bool: true)
       
        switch collectionSelectIndex.row {
        case 0:
            getZipCode(city: self.cityPickerNames[self.pickerView.pickerView.selectedRow(inComponent: 0)], area: "") { _ -> (Void) in
                
            }
            self.cellDefaultTitleArr[0] = self.cityPickerNames[self.pickerView.pickerView.selectedRow(inComponent: 0)]
        case 1:
            getZipCode(city: "", area: self.areaPickerNames[self.pickerView.pickerView.selectedRow(inComponent: 0)]) { _ -> (Void) in
            }
            self.cellDefaultTitleArr[1] = self.areaPickerNames[self.pickerView.pickerView.selectedRow(inComponent: 0)]
        case 2:
            self.cellDefaultTitleArr[2] = self.roadPickerNames[self.pickerView.pickerView.selectedRow(inComponent: 0)]
            
            
        default:
            break
        }
        
        self.collectionView.reloadData()
        
    }
    
    @objc func cancelAction() {
        self.pickerViewIsHidden(bool: true)
    }
    
    @IBAction func onSearchBtnClick(_ sender: UIButton) {
        print(self.cellDefaultTitleArr)
        
        guard let models = self.zipFiveModel else { return }
        
        var newZipFiveArr = [String]()
        var newAreaArr = [String]()
        var newRoadArr = [String]()
        var newScopeArr = [String]()
        
        for model in models {
            if model.city == self.cellDefaultTitleArr[0] && model.area == self.cellDefaultTitleArr[1] && model.road == self.cellDefaultTitleArr[2] {
                print(model)
                
                newZipFiveArr.append(model.zip5)
                newAreaArr.append(model.area)
                newRoadArr.append(model.road)
                newScopeArr.append(model.scope)
                
            }
            
            self.zipFiveArr = newZipFiveArr
            self.areaArr = newAreaArr
            self.roadArr = newRoadArr
            self.scopeArr = newScopeArr
        }
        
        self.tableView.reloadData()
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
            ]
        )
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
        print(collectionSelectIndex)
        switch indexPath.row {
        case 0:
            self.pickerView.labels = self.cityPickerNames
        case 1:
            self.pickerView.labels = self.areaPickerNames
        case 2:
            self.pickerView.labels = self.roadPickerNames
        default:
            break
        }
        
        self.pickerViewIsHidden(bool: false)
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
        return 36 * screenSceleHeight
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
        self.pickerViewTop.constant = bool ? 50 : -257
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
