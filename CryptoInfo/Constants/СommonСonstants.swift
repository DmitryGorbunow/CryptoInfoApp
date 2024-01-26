//
//  СommonСonstants.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/25/24.
//

import UIKit

extension CGFloat {
    static var offset2: CGFloat { 2 }
    static var offset10: CGFloat { 10 }
    static var offset12: CGFloat { 12 }
    static var offset20: CGFloat { 20 }
    static var offset24: CGFloat { 24 }
    static var offset32: CGFloat { 32 }
    static var offset35: CGFloat { 35 }
    static var offset48: CGFloat { 48 }
}

enum Fonts {
    static let xs = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let s = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let m = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let l = UIFont.systemFont(ofSize: 24, weight: .regular)
    @available(iOS 16.0, *)
    static let lExt = UIFont.systemFont(ofSize: 24, weight: .semibold, width: .expanded)
}

struct StringValues {
    static let trendingCoins = NSLocalizedString("Trending Coins", comment: "")
    static let searchBySymbolOrName = NSLocalizedString("Search by symbol or name", comment: "")
    static let marketCap = NSLocalizedString("Market Cap", comment: "")
    static let supply = NSLocalizedString("Supply", comment: "")
    static let volume24Hr = NSLocalizedString("Volume 24Hr", comment: "")
    static let noResults = NSLocalizedString("No results", comment: "")
    static let noData = NSLocalizedString("No data", comment: "")
}

enum API: String {
    case baseURL = "https://api.coincap.io"
    case path = "/v2/assets"
    case search = "search"
    case limit = "limit"
    case offset = "offset"
    case assetsLimit = "10"
    case additionalNumber = "0"
}
