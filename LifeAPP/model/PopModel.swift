//
//  PopModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/27.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - POPModel
struct POPModel: Codable {
    let success: String
    let result: PopResult
    let records: PopRecords
}

// MARK: - Records
struct PopRecords: Codable {
    let datasetDescription: String
    let location: [PopLocation]
}

// MARK: - Location
struct PopLocation: Codable {
    let locationName: String
    let weatherElement: [PopWeatherElement]
}

// MARK: - WeatherElement
struct PopWeatherElement: Codable {
    let elementName: String
    let time: [PopTime]
}

// MARK: - Time
struct PopTime: Codable {
    let startTime, endTime: String
    let parameter: PopParameter
}

// MARK: - Parameter
struct PopParameter: Codable {
    let parameterName, parameterUnit: String
}

// MARK: - Result
struct PopResult: Codable {
    let resourceID: String
    let fields: [PopField]

    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields
    }
}

// MARK: - Field
struct PopField: Codable {
    let id, type: String
}
