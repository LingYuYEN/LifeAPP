//
//  VersionModel.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/24.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import Foundation

struct VersionModel: Codable {
    let resultCount: Int
    let results: [VersionResult]
}

// MARK: - Result
struct VersionResult: Codable {
    let screenshotUrls: [String]
    let artworkUrl60, artworkUrl512, artworkUrl100: String
    let artistViewURL: String
    let supportedDevices: [String]
    let isGameCenterEnabled: Bool
    let kind: String
    let trackCensoredName: String
    let languageCodesISO2A: [String]
    let fileSizeBytes, contentAdvisoryRating: String
    let averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, averageUserRating: Int
    let trackViewURL: String
    let trackContentRating: String
    let trackID: Int
    let trackName: String
    let genreIDS: [String]
    let formattedPrice, primaryGenreName: String
    let isVppDeviceBasedLicensingEnabled: Bool
    let minimumOSVersion: String
    let currentVersionReleaseDate: Date
    let releaseNotes: String
    let primaryGenreID: Int
    let sellerName, currency, version, wrapperType: String
    let resultDescription: String
    let artistID: Int
    let artistName: String
    let genres: [String]
    let price: Int
    let bundleID: String
    let userRatingCount: Int

}
