//
//  GeocodeManager.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/28.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import MapKit

class GeocodeManager {
    private static let instance = GeocodeManager()
    static var shared: GeocodeManager {
        return self.instance
    }
    
    //for iOS 11.0
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        //1
        let locale = Locale(identifier: "zh_TW")
        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: locale) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                completion(nil, error)
                return
            }
            completion(placemark, nil)
            }
        }
    }
}

enum LocationName: String {
    case taipei = "臺北市"
    case newTaipei = "新北市"
    case keelung = "基隆市"
    case yilan = "宜蘭縣"
    case taoyuan = "桃園市"
    case hsinchu = "新竹縣"
    case hsinchuCity = "新竹市"
    case miaoli = "苗栗縣"
    case taichung = "臺中市"
    case changhua = "彰化縣"
    case nantou = "南投縣"
    case yunlin = "雲林縣"
    case chiayi = "嘉義縣"
    case chiayiCity = "嘉義市"
    case tainan = "臺南市"
    case kaohsiung = "高雄市"
    case pingtung = "屏東縣"
    case hualien = "花蓮縣"
    case taitung = "臺東縣"
    case kinmen = "金門縣"
    case lianjiang = "連江縣"
    case penghu = "澎湖縣"
}
