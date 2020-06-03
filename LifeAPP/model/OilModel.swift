//
//  OilModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/3.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

// MARK: - OilModel
struct OilModel: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [OilResult]
}

// MARK: - Result
struct OilResult: Codable {
    let id: Int
    let dieselChange: Double
    let priceLevel92, priceLevel95, priceLevel98, priceLevelDisel: Int
    let createdAt: String
    let cpcOil92, cpcOil95, cpcOil98, cpcDieselOil: Double
    let fpcOil92, fpcOil95, fpcOil98, fpcDieselOil: Double
    let oilChange: Double
    let lastUpdatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case dieselChange = "diesel_change"
        case priceLevel92 = "price_level_92"
        case priceLevel95 = "price_level_95"
        case priceLevel98 = "price_level_98"
        case priceLevelDisel = "price_level_disel"
        case createdAt = "created_at"
        case cpcOil92 = "CPC_oil_92"
        case cpcOil95 = "CPC_oil_95"
        case cpcOil98 = "CPC_oil_98"
        case cpcDieselOil = "CPC_diesel_oil"
        case fpcOil92 = "FPC_oil_92"
        case fpcOil95 = "FPC_oil_95"
        case fpcOil98 = "FPC_oil_98"
        case fpcDieselOil = "FPC_diesel_oil"
        case oilChange = "oil_change"
        case lastUpdatedAt = "last_updated_at"
    }
}
