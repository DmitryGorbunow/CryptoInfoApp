//
//  String + Extension.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/25/24.
//

import Foundation

extension String {
    func formatCurrency() -> String {
        if let number = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$ "
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            if let formattedString = formatter.string(from: NSNumber(value: number)) {
                return formattedString
            }
        }
        return StringValues.noData
    }
    
    func formatChangePercent() -> String {
        if let number = Double(self) {
            let isPositivePercent = number >= 0
            let formattedString = String(format: "%@ %.2f%%", isPositivePercent ? "+": "-", abs(number))
            return formattedString
        }
        return StringValues.noData
    }
    
    func roundedWithAbbreviations(haveSign: Bool) -> String {
        if let number = Double(self) {
            switch number {
            case ..<1_000:
                return "\(haveSign ? "$" : "")\(String(format: "%.0f", number))"
            case 1_000 ..< 999_999:
                return "\(haveSign ? "$" : "")\(String(format: "%.2fk", number / 1_000))"
            case 1_000_000 ..< 999_999_999:
                return "\(haveSign ? "$" : "")\(String(format: "%.2fm", number / 1_000_000))"
            default:
                return "\(haveSign ? "$" : "")\(String(format: "%.2fb", number / 1_000_000_000))"
            }
        }
        return StringValues.noData
    }
    
    func formatPriceAndPercent(changePercent24Hr: String) -> String {
        if let price = Double(self), let percent = Double(changePercent24Hr) {
            let changePrice = price * (abs(percent) / 100.0)
            return "\(percent < 0 ? "-" : "+") " +
            String(format: "%.2f", changePrice) + " " + 
            "(" + String(format: "%.2f", abs(percent)) + "%" + ")"
        }
        return StringValues.noData
    }
}


