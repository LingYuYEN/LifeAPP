//
//  CWBModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/2.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - CWBModel
struct CWBModel: Codable {
    let cwbopendata: Cwbopendata
}

// MARK: - Cwbopendata
struct Cwbopendata: Codable {
    let xmlns, identifier, sender: String
    let sent: String
    let status, msgType, scope, dataid: String
    let source: String
    let dataset: Dataset

    enum CodingKeys: String, CodingKey {
        case xmlns = "@xmlns"
        case identifier, sender, sent, status, msgType, scope, dataid, source, dataset
    }
}

// MARK: - Dataset
struct Dataset: Codable {
    let datasetInfo: DatasetInfo
    let location: CWBLocation
    let parameterSet: ParameterSet
}

// MARK: - DatasetInfo
struct DatasetInfo: Codable {
    let datasetDescription, datasetLanguage: String
    let issueTime: String
}

// MARK: - Location
struct CWBLocation: Codable {
    let locationName, stationID, geocode: String

    enum CodingKeys: String, CodingKey {
        case locationName
        case stationID = "stationId"
        case geocode
    }
}

// MARK: - ParameterSet
struct ParameterSet: Codable {
    let parameterSetName: String
    let parameter: [CWBParameter]
}

// MARK: - Parameter
struct CWBParameter: Codable {
    let parameterValue: String
}
