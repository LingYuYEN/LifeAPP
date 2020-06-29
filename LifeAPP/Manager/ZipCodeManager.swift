//
//  ZipCodeManager.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/24.
//  Copyright © 2020 顏淩育. All rights reserved.
//
import UIKit

final class ZipCodeManager {
    
    static let shared: ZipCodeManager = ZipCodeManager()
    
    let models: [ZipFiveModel]
    
    init() {
        guard
            let resourcePath = Bundle.main.path(forResource: "Zip5", ofType: "json")
            else {
            assertionFailure("Load Zip Json File Error.")
            self.models = []
            return
        }
        
        do {
            let data = try NSData(contentsOfFile: resourcePath) as Data
            let m = try JSONDecoder().decode([ZipFiveModel].self, from: data)
            self.models = m
        } catch {
            assertionFailure("Load Zip Json File Error.")
            self.models = []
        }
    }
    
    func search(city: String, area: String, road: String) -> [ZipFiveModel] {
        
        if city == "", area == "", road == "" { return [] }
        
        return models.filter {
            var success: Bool = true
            if city != "" { success = $0.city == city }
            if success, area != "" { success = $0.area == area }
            if success, road != "" { success = $0.road == road }
            return success
        }
    }
}
