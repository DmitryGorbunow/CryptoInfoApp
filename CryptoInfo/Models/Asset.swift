//
//  AssetModel.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/23/24.
//

import Foundation

struct Asset: Codable {
    let symbol: String
    let name: String
    let supply: String
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String
    let changePercent24Hr: String?
}

struct AssetResponse: Codable {
    let data: [Asset]
}
