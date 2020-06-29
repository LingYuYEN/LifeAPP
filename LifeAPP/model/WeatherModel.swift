//
//  WetherModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/8.
//  Copyright © 2020 顏淩育. All rights reserved.
//
//   let wetherModel = try? newJSONDecoder().decode(WetherModel.self, from: jsonData)


import Foundation

// MARK: - WetherModel
struct WeatherModel: Codable {
    let weather: Weather
    let aqi: Aqi
    let uvi: Uvi
    let rain: Rain
    let descriptions: [Description]
}

// MARK: - Aqi
struct Aqi: Codable {
    let aqi, pm25, pm10, o3: Double?
    let location: String?
    let site: String?
}

// MARK: - Description
struct Description: Codable {
    let descriptionDescription: String?

    enum CodingKeys: String, CodingKey {
        case descriptionDescription = "description"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let pop: Int?
    let location: String?
}

// MARK: - Uvi
struct Uvi: Codable {
    let uvi: Double?
    let location: String?
    let site: String?

    enum CodingKeys: String, CodingKey {
        case uvi = "UVI"
        case location, site
    }
}

// MARK: - Weather
struct Weather: Codable {
    let temp, maxT, minT: Int?
    let wx: String?
    let weekMaxT, weekMinT, weekWx: [Week]
    let location, wxDescription: String?

    enum CodingKeys: String, CodingKey {
        case temp, maxT, minT, wx, weekMaxT, weekMinT, weekWx, location
        case wxDescription = "wx_description"
    }
}

// MARK: - Week
struct Week: Codable {
    let startTime, endTime, value: String?
    let location: String?
//    let valueDescription: String?

    enum CodingKeys: String, CodingKey {
        case startTime, endTime, value, location
//        case valueDescription = "value_description"
    }
}

