//
//  ZipFiveModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/22.
//  Copyright © 2020 顏淩育. All rights reserved.
//   let postalModel = try? newJSONDecoder().decode(PostalModel.self, from: jsonData)

import Foundation

typealias PostalModel = [ZipFiveModel]
// MARK: - PostalModelElement
struct ZipFiveModel: Codable {
    let zip5: String
    let city: String
    let area, road, scope: String

    enum CodingKeys: String, CodingKey {
        case zip5 = "Zip5"
        case city = "City"
        case area = "Area"
        case road = "Road"
        case scope = "Scope"
    }
}

enum City: String, Codable {
    case 南投縣 = "南投縣"
    case 南海島 = "南海島"
    case 嘉義市 = "嘉義市"
    case 嘉義縣 = "嘉義縣"
    case 基隆市 = "基隆市"
    case 宜蘭縣 = "宜蘭縣"
    case 屏東縣 = "屏東縣"
    case 彰化縣 = "彰化縣"
    case 新北市 = "新北市"
    case 新竹市 = "新竹市"
    case 新竹縣 = "新竹縣"
    case 桃園市 = "桃園市"
    case 澎湖縣 = "澎湖縣"
    case 臺中市 = "臺中市"
    case 臺北市 = "臺北市"
    case 臺南市 = "臺南市"
    case 臺東縣 = "臺東縣"
    case 花蓮縣 = "花蓮縣"
    case 苗栗縣 = "苗栗縣"
    case 連江縣 = "連江縣"
    case 金門縣 = "金門縣"
    case 釣魚臺 = "釣魚臺"
    case 雲林縣 = "雲林縣"
    case 高雄市 = "高雄市"
}
