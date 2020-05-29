//
//  OneWeekWetherModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/29.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - OneWeekWetherModel
struct OneWeekWetherModel: Codable {
    let success: String
    let result: OneWeekWetherResult
    let records: OneWeekWetherRecords
}

// MARK: - Records
struct OneWeekWetherRecords: Codable {
    let locations: [RecordsLocation]
}

// MARK: - RecordsLocation
struct RecordsLocation: Codable {
    let datasetDescription, locationsName, dataid: String
    let location: [LocationLocation]
}

// MARK: - LocationLocation
struct LocationLocation: Codable {
    let locationName, geocode, lat, lon: String
    let weatherElement: [OneWeekWetherWeatherElement]
}

// MARK: - WeatherElement
struct OneWeekWetherWeatherElement: Codable {
    let elementName, weatherElementDescription: String
    let time: [OneWeekWetherTime]

    enum CodingKeys: String, CodingKey {
        case elementName
        case weatherElementDescription = "description"
        case time
    }
}

// MARK: - Time
struct OneWeekWetherTime: Codable {
    let startTime, endTime: String
    let elementValue: [ElementValue]
}

// MARK: - ElementValue
struct ElementValue: Codable {
    let value: String
    let measures: Measures
}

enum Measures: String, Codable {
    case measuresNA = "NA "
    case na = "NA"
    case the16方位 = "16方位"
    case 公尺秒 = "公尺/秒"
    case 攝氏度 = "攝氏度"
    case 曝曬級數 = "曝曬級數"
    case 百分比 = "百分比"
    case 紫外線指數 = "紫外線指數"
    case 自定義Wx單位 = "自定義 Wx 單位"
    case 自定義Wx文字 = "自定義 Wx 文字"
    case 蒲福風級 = "蒲福風級"
}

//enum EndTimeEnum: String, Codable {
//    case the20200529120000 = "2020-05-29 12:00:00"
//    case the20200529180000 = "2020-05-29 18:00:00"
//    case the20200530060000 = "2020-05-30 06:00:00"
//    case the20200530180000 = "2020-05-30 18:00:00"
//    case the20200531060000 = "2020-05-31 06:00:00"
//    case the20200531180000 = "2020-05-31 18:00:00"
//    case the20200601060000 = "2020-06-01 06:00:00"
//    case the20200601180000 = "2020-06-01 18:00:00"
//    case the20200602060000 = "2020-06-02 06:00:00"
//    case the20200602180000 = "2020-06-02 18:00:00"
//    case the20200603060000 = "2020-06-03 06:00:00"
//    case the20200603180000 = "2020-06-03 18:00:00"
//    case the20200604060000 = "2020-06-04 06:00:00"
//    case the20200604180000 = "2020-06-04 18:00:00"
//    case the20200605060000 = "2020-06-05 06:00:00"
//}

// MARK: - Result
struct OneWeekWetherResult: Codable {
    let resourceID: String
    let fields: [OneWeekWetherField]

    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields
    }
}

// MARK: - Field
struct OneWeekWetherField: Codable {
    let id: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case double = "Double"
    case string = "String"
    case timestamp = "Timestamp"
}
