//
//  UVIModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/27.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - UVIModelElement
struct UVIModelElement: Codable {
    let county: String
    let publishAgency: PublishAgency
    let publishTime: String
    let siteName, uvi, wgs84Lat, wgs84Lon: String

    enum CodingKeys: String, CodingKey {
        case county = "County"
        case publishAgency = "PublishAgency"
        case publishTime = "PublishTime"
        case siteName = "SiteName"
        case uvi = "UVI"
        case wgs84Lat = "WGS84Lat"
        case wgs84Lon = "WGS84Lon"
    }
}

enum PublishAgency: String, Codable {
    case 中央氣象局 = "中央氣象局"
    case 環境保護署 = "環境保護署"
}

//enum PublishTime: String, Codable {
//    case the202005271500 = "2020-05-27 15:00"
//}

typealias UVIModel = [UVIModelElement]
