
//
//  WetherModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/26.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

protocol InvestmentReportProtocol {
    
}

// MARK: - WetherModel
struct WetherModel: Codable {
    let success: String
    let result: Result
    let records: Records
}

// MARK: - Records
struct Records: Codable {
    let location: [Location]
}

// MARK: - Location
struct Location: Codable {
    let lat, lon, locationName, stationID: String
    let time: Time
    let weatherElement: [WeatherElement]
    let parameter: [Parameter]

    enum CodingKeys: String, CodingKey {
        case lat, lon, locationName
        case stationID = "stationId"
        case time, weatherElement, parameter
    }
}

// MARK: - Parameter
struct Parameter: Codable {
    let parameterName: ParameterName
    let parameterValue: String
}

enum ParameterName: String, Codable {
    case city = "CITY"
    case citySn = "CITY_SN"
    case town = "TOWN"
    case townSn = "TOWN_SN"
}

// MARK: - Time
struct Time: Codable {
    let obsTime: String
}

//enum ObsTime: String, Codable {
//    case the20200526153000 = "2020-05-26 15:30:00"
//}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let elementName: ElementName
    let elementValue: String
}

enum ElementName: String, Codable {
    case dTn = "D_TN"
    case dTnt = "D_TNT"
    case dTs = "D_TS"
    case dTx = "D_TX"
    case dTxt = "D_TXT"
    case elev = "ELEV"
    case h10D = "H_10D"
    case hF10 = "H_F10"
    case hF10T = "H_F10T"
    case hFx = "H_FX"
    case hFxt = "H_FXT"
    case hUvi = "H_UVI"
    case hVis = "H_VIS"
    case hWeather = "H_Weather"
    case hXd = "H_XD"
    case humd = "HUMD"
    case pres = "PRES"
    case temp = "TEMP"
    case the24R = "24R"
    case wdir = "WDIR"
    case wdsd = "WDSD"
}

// MARK: - Result
struct Result: Codable {
    let resourceID: String
    let fields: [Field]

    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields
    }
}

// MARK: - Field
struct Field: Codable {
    let id, type: String
}
