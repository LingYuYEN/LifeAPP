//
//  AQIModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/27.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - AQIModelElement
struct AQIModelElement: Codable {
    let siteName, county, aqi, pollutant: String
    let status: Status
    let so2, co, co8Hr, o3: String
    let o38Hr, pm10, pm25, no2: String
    let nOx, no, windSpeed, windDirec: String
    let publishTime: String
    let pm25_Avg, pm10Avg, so2Avg, longitude: String
    let latitude, siteID: String

    enum CodingKeys: String, CodingKey {
        case siteName = "SiteName"
        case county = "County"
        case aqi = "AQI"
        case pollutant = "Pollutant"
        case status = "Status"
        case so2 = "SO2"
        case co = "CO"
        case co8Hr = "CO_8hr"
        case o3 = "O3"
        case o38Hr = "O3_8hr"
        case pm10 = "PM10"
        case pm25 = "PM2.5"
        case no2 = "NO2"
        case nOx = "NOx"
        case no = "NO"
        case windSpeed = "WindSpeed"
        case windDirec = "WindDirec"
        case publishTime = "PublishTime"
        case pm25_Avg = "PM2.5_AVG"
        case pm10Avg = "PM10_AVG"
        case so2Avg = "SO2_AVG"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case siteID = "SiteId"
    }
}

//enum PublishTime: String, Codable {
//    case the202005271400 = "2020-05-27 14:00"
//}

enum Status: String, Codable {
    case 良好 = "良好"
    case 普通 = "普通"
    case 對敏感族群不良 = "對敏感族群不健康"
    case 對所有族群不良 = "對所有族群不良"
    case 非常不良 = "非常不良"
    case 有害 = "有害"
    case 設備維護 = "設備維護"
}

typealias AQIModel = [AQIModelElement]

/**
 AQI值0～50空氣品質為「良好」，
 51～100空氣品質為「普通」，
 101~150空氣品質為「對敏感族群不健康」，
 151~200空氣品質為「對所有族群不良」，
 201~300空氣品質為「非常不良」，
 301~500空氣品質為「有害」。
 */
