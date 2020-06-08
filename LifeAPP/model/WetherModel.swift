//
//  WetherModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/8.
//  Copyright © 2020 顏淩育. All rights reserved.
//
//   let wetherModel = try? newJSONDecoder().decode(WetherModel.self, from: jsonData)


import Foundation

import Foundation

// MARK: - WetherModel
struct WetherModel: Codable {
    let weather: Weather
    let aqi: Aqi
    let uvi: Double
    let rain: Rain
    let descriptions: [Description]
}

// MARK: - Aqi
struct Aqi: Codable {
    let aqi, pm25, pm10, o3: Int
}

// MARK: - Description
struct Description: Codable {
    let descriptionDescription: String

    enum CodingKeys: String, CodingKey {
        case descriptionDescription = "description"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let pop: Int
}

// MARK: - Weather
struct Weather: Codable {
    let temp, maxT, minT: Int
    let wx: String
    let weekMaxT, weekMinT, weekWx: [Week]
}

// MARK: - Week
struct Week: Codable {
    let startTime, endTime, value: String
}
