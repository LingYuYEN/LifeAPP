//
//  DataManager.swift
//  DemoCOC
//
//  Created by 顏淩育 on 2020/3/3.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
var loadingTimeout = false
class DataManager {
    private static let instance = DataManager()
    static var shared: DataManager {
        return self.instance
    }
    
    let baseUrl = "https://opendata.cwb.gov.tw/api"
    let wetherApiKey = "CWB-CB4BCD6A-E710-4672-A9BF-8DB65AAA81CD"
 
    var appVersion = String()
    
    /// 取得在 Apple 的版本，並判斷是否需要更新
    func getAppVersionWithWeb(completed: @escaping (Bool) -> (Void)) {
        
        // 使用者當前 APP 版本
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            self.appVersion = appVersion
        }
        
        let urlStr = "http://itunes.apple.com/tw/lookup?bundleId=co.conquers.LifeAPP"
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
                let results = json["results"] as! [[String : Any]]
                let versionStr = results[0]["version"] as! String                
                
                // return true 則代表需更新
                print("使用者安裝版本: ", self.appVersion)
                print("架上版本: ", versionStr)
                completed(self.appVersion != versionStr)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    
    
    
    /// 取得天氣資訊
    func getWeather(lat: Double, lon: Double, city: String, completed: @escaping (WeatherModel?, Bool?) -> (Void)) {
    //    let urlStr = "http://172.104.71.209:2000/api/weather/?lat=22.631505&lon=120.296738&city=%E9%AB%98%E9%9B%84%E5%B8%82"
        
        let urlStr = "http://172.104.71.209:2000/api/weather/?lat=\(lat)&lon=\(lon)&city=\(city)"
        guard let newUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: newUrlStr) else { return }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(10.0)
        sessionConfig.timeoutIntervalForResource = TimeInterval(10.0)
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url) { (data, res, error) in
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(WeatherModel.self, from: data)
                completed(model, false)
            } catch {
                completed(nil, true)
                print("Error: ", error)
            }
        }
        task.resume()
    }
    
    /// 取得油價資訊
    func getOil(completed: @escaping (OilModel?, Bool?) -> (Void)) {
        let urlStr = "http://172.104.71.209:2000/api/oil/?limit=1&offset=0"
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(OilModel.self, from: data)
                completed(model, false)
            } catch {
                completed(nil, true)
                print(error)
            }
        }
        task.resume()
    }
    
    /// 取得郵遞資訊（3+2）
    func getZipFive(completed: @escaping ([ZipFiveModel]?, Error?) -> (Void)) {
        
        guard let url = Bundle.main.url(forResource: "Zip5", withExtension:"json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode([ZipFiveModel].self, from: data)
                completed(model, nil)
            } catch {
                print("error:\(error)")
                completed(nil, error)
            }
        }
        task.resume()
    }
    
    
}
