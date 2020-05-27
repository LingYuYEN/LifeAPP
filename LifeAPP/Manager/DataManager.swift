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
    
    // 取得天氣資訊
    func getWether(baseUrl: String, wetherApiKey: String, _ completion: @escaping () -> Void) {
        defer {
            DispatchQueue.main.async {
                completion()
            }
        }
        
        let urlStr = "\(baseUrl)/v1/rest/datastore/O-A0003-001?Authorization=\(wetherApiKey)&parameterName=CITY"
//        let header = ["Content-Type" : "charset=utf-8"]
        
        // 若url內容包含中文字，請以下列進行編碼
//        guard let newUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlStr) else { return }
        
        ClientManager.shared.getJsonData(method: .get, url: url) { data in
            guard let data = data else { return }
            guard let dataStr = String(data: data, encoding: .utf8) else { return }
            print(data)
            print(dataStr + "sdfsdlgijlerijbelrigjl")
        }
    }
    
    
    
}

