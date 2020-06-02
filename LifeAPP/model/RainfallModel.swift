//
//  RainfallModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/2.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - RainfallModel
struct RainfallModel: Codable {
    let success: String
    let records: RainfallRecords
}

// MARK: - Records
struct RainfallRecords: Codable {
    let location: [RainfallLocation]
}

// MARK: - Location
struct RainfallLocation: Codable {
    let lat, lon, locationName, stationID: String
    let time: RainfallTime
    let weatherElement: [RainfallWeatherElement]
    let parameter: [RainfallParameter]

    enum CodingKeys: String, CodingKey {
        case lat, lon, locationName
        case stationID = "stationId"
        case time, weatherElement, parameter
    }
}

// MARK: - Parameter
struct RainfallParameter: Codable {
    let parameterName, parameterValue: String
}

// MARK: - Time
struct RainfallTime: Codable {
    let obsTime: String
}

// MARK: - WeatherElement
struct RainfallWeatherElement: Codable {
    let elementName, elementValue: String
}
