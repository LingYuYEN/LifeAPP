//
//  DataManager.swift
//  DemoCOC
//
//  Created by 顏淩育 on 2020/3/3.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class DataManager {
    private static let instance = DataManager()
    static var shared: DataManager {
        return self.instance
    }
    
    let baseUrl = "https://opendata.cwb.gov.tw/api"
    let wetherApiKey = "CWB-CB4BCD6A-E710-4672-A9BF-8DB65AAA81CD"
    
    /// 取得天氣資訊
//    func getWether(baseUrl: String, wetherApiKey: String, _ completion: @escaping () -> Void) {
//        defer {
//            DispatchQueue.main.async {
//                completion()
//            }
//        }
//
//        let urlStr = "\(baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(wetherApiKey)&parameterName=CITY"
////        let header = ["Content-Type" : "charset=utf-8"]
//
//        // 若url內容包含中文字，請以下列進行編碼
////        guard let newUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        guard let url = URL(string: urlStr) else { return }
//
//        ClientManager.shared.getJsonData(method: .get, url: url) { data in
//            guard let data = data else { return }
//            guard let dataStr = String(data: data, encoding: .utf8) else { return }
//            print(data)
//            print(dataStr)
//        }
//    }
    
//    /// 取得雨量資訊
//    func getRain(range: String, locationName: String, completed: @escaping (String?) -> (Void)) {
//        let urlStr = "\(baseUrl)/v1/rest/datastore/O-A0002-001?Authorization=\(wetherApiKey)&locationName=\(locationName)&elementName=\(range)&parameterName=CITY"
//        guard let newUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        guard let url = URL(string: newUrlStr) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else { return}
//            do {
//                let model = try JSONDecoder().decode(RainfallModel.self, from: data)
//                guard let the24R = model.records.location.first!.weatherElement.first?.elementValue else { return }
//                completed(the24R)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    /// 取得小幫手文字
//    func getCWB(locationID: String, completed: @escaping (String?) -> (Void)) {
//        let urlStr = "https://opendata.cwb.gov.tw/fileapi/v1/opendataapi/\(locationID)?Authorization=\(wetherApiKey)&downloadType=WEB&format=JSON"
//        guard let url = URL(string: urlStr) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
//            guard let data = data else { return }
//            do {
//                let model = try JSONDecoder().decode(CWBModel.self, from: data)
//                let parameterCount = model.cwbopendata.dataset.parameterSet.parameter.count
//                let number = Int.random(in: 0 ... parameterCount - 1)
//                let parameter = model.cwbopendata.dataset.parameterSet.parameter[number].parameterValue
//                completed(parameter)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
    
    
    
    /// 取得天氣資訊
    func getWeather(lat: Double, lon: Double, city: String, completed: @escaping (WetherModel?) -> (Void)) {
    //    let urlStr = "http://172.104.71.209:2000/api/weather/?lat=22.631505&lon=120.296738&city=%E9%AB%98%E9%9B%84%E5%B8%82"
        
        let urlStr = "http://172.104.71.209:2000/api/weather/?lat=\(lat)&lon=\(lon)&city=\(city)"
        guard let newUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: newUrlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(WetherModel.self, from: data)
                completed(model)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    /// 取得油價資訊
    func getOil(completed: @escaping (OilModel?) -> (Void)) {
        let urlStr = "http://172.104.71.209:2000/api/oil/?limit=1&offset=0"
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(OilModel.self, from: data)
                completed(model)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

