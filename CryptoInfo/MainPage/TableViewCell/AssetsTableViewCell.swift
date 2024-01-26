//
//  AssetsTableViewCell.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/23/24.
//

import UIKit
import Kingfisher

private enum Constants {
    static let url = "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@1a63530be6e374711a8554f31b17e4cb92c25fa5/128/color/"
    static let expansion = ".png"
    static let opacity: Float = 0.7
    static let alpha: CGFloat = 0.5
}

class AssetsTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Components
    private let nameLabel = CustomLabel(font: Fonts.m)
    private let symbolLabel = CustomLabel(font: Fonts.s, textColor: .white.withAlphaComponent(Constants.alpha))
    private let priceLabel = CustomLabel(font: Fonts.m)
    private let changeLabel = CustomLabel(font: Fonts.s)
    
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.opacity = Constants.opacity
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinImageView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
    }
    
    // MARK: - Private Funcs
    private func setupViews() {
        backgroundColor = .clear
        addSubview(coinImageView)
        addSubview(nameLabel)
        addSubview(symbolLabel)
        addSubview(priceLabel)
        addSubview(changeLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            coinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .offset20),
            coinImageView.topAnchor.constraint(equalTo: topAnchor, constant: .offset12),
            coinImageView.heightAnchor.constraint(equalToConstant: .offset48),
            coinImageView.widthAnchor.constraint(equalToConstant: .offset48),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: .offset12),
            nameLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: .offset10),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .offset2),
            symbolLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: .offset10),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: .offset12),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.offset20),

            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: .offset2),
            changeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.offset20),
        ])
    }
    
    private func checkPositivity(numberString: String) {
        if let number = Double(numberString) {
            changeLabel.textColor = number >= 0 ? .customGreen : .customRed
        } else {
            changeLabel.textColor = .white
        }
    }
    
    // MARK: - Funcs
    func configure(with asset: Asset) {
        nameLabel.text = asset.name
        symbolLabel.text = asset.symbol
        priceLabel.text = asset.priceUsd.formatCurrency()
        changeLabel.text = asset.changePercent24Hr?.formatChangePercent() ?? StringValues.noData
        checkPositivity(numberString: asset.changePercent24Hr ?? StringValues.noData)
        coinImageView.kf.setImage(
            with: URL(string: Constants.url + asset.symbol.lowercased() + Constants.expansion),
            placeholder: UIImage.noimage
        )
    }
}

