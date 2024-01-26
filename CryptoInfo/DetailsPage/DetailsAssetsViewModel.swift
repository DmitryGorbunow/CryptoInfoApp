//
//  DetailsAssetsViewModel.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/25/24.
//

import Foundation

protocol DetailsAssetsViewModelProtocol {
    var titleLabel: String { get }
    var priceLabel: String { get }
    var changeLabel: String { get }
    var marketCapLabel: String { get }
    var supplyLabel: String { get }
    var volume24HrLabel: String { get }
    var isPositivePercent: Bool { get }
}

final class DetailsAssetsViewModel: DetailsAssetsViewModelProtocol {
    
    // MARK: - Variables
    private let asset: Asset
    var isPositivePercent: Bool = false
    
    // MARK: - Initializer
    init(asset: Asset) {
        self.asset = asset
        checkPositivity()
    }
    
    // MARK: - Computed Properties
    var titleLabel: String {
        return asset.name
    }
    
    var priceLabel: String {
        return asset.priceUsd.formatCurrency()
    }
    
    var changeLabel: String {
        return asset.priceUsd.formatPriceAndPercent(changePercent24Hr: asset.changePercent24Hr ?? StringValues.noData)
    }
    
    var marketCapLabel: String {
        return asset.marketCapUsd?.roundedWithAbbreviations(haveSign: true) ?? StringValues.noData
    }
    
    var supplyLabel: String {
        return asset.supply.roundedWithAbbreviations(haveSign: false)
    }
    
    var volume24HrLabel: String {
        return asset.volumeUsd24Hr?.roundedWithAbbreviations(haveSign: true) ?? StringValues.noData
    }
    
    private func checkPositivity() {
        if let number = Double(asset.changePercent24Hr ?? StringValues.noData) {
            isPositivePercent = number >= 0
        }
    }
}

