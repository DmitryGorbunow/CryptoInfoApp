//
//  CustomLabel.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/26/24.
//

import UIKit

final class CustomLabel: UILabel {
    
    // MARK: - init
    init(title: String = "", font: UIFont, textColor: UIColor = .white) {
        super.init(frame: .zero)
        self.text = title
        self.textColor = textColor
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
