//
//  DetailsAssetsViewController.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/23/24.
//

import UIKit

private enum Constants {
    static let alpha4: CGFloat = 0.4
    static let alpha1: CGFloat = 0.1
    static let kern: CGFloat = 0.48
    static let textFieldCornerRadius: CGFloat = 12
    static let buttonSize: CGFloat = 40
    static let multiplier: CGFloat = 0.6
}

class DetailsAssetsViewController: UIViewController {
    
    // MARK: - Variables
    let viewModel: DetailsAssetsViewModelProtocol
    
    // MARK: - UI Components
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bg
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.l
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var changeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.s
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let marketCapDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = StringValues.marketCap
        label.textColor = .gray
        label.font = Fonts.xs
        return label
    }()
    
    private let supplyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = StringValues.supply
        label.textColor = .gray
        label.font = Fonts.xs
        return label
    }()
    
    private let volume24HrDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = StringValues.volume24Hr
        label.textColor = .gray
        label.font = Fonts.xs
        return label
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.m
        return label
    }()
    
    private let supplyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.m
        return label
    }()
    
    private let volume24HrLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.m
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: Constants.buttonSize, height: Constants.buttonSize)
        button.layer.cornerRadius = Constants.textFieldCornerRadius
        button.layer.borderWidth = 1
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.withAlphaComponent(Constants.alpha1).cgColor
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.lExt
        return label
    }()
    
    // MARK: - Initializer
    init(viewModel: DetailsAssetsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupInfoStackView()
        configure()
    }
    
    // MARK: - Privat Funcs
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(priceLabel)
        view.addSubview(changeLabel)
        view.addSubview(infoStackView)
        setupConstraints()
        setupNavBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset32),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset20),
            
            changeLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            changeLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: .offset10),
            
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset20),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset20),
            infoStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: .offset24),
            infoStackView.heightAnchor.constraint(equalToConstant: .offset35)
        ])
    }
    
    private func setupNavBar() {
        let backBarButton = UIBarButtonItem(customView: backButton)
        let titleBarLabel = UIBarButtonItem(customView: titleLabel)
        navigationItem.setLeftBarButtonItems([backBarButton, titleBarLabel], animated: true)
    }
    
    private func setupInfoStackView() {
        let descriptions = [marketCapDescriptionLabel, supplyDescriptionLabel, volume24HrDescriptionLabel]
        let values = [marketCapLabel, supplyLabel, volume24HrLabel]
        
        for i in 0..<descriptions.count {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.addArrangedSubview(descriptions[i])
            stack.addArrangedSubview(values[i])
            
            if i == 1 || i == 2 {
                let separator = UIView()
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.alpha = Constants.alpha4
                separator.backgroundColor = .darkGray
                infoStackView.addArrangedSubview(separator)
                separator.heightAnchor.constraint(equalTo: infoStackView.heightAnchor, multiplier: Constants.multiplier).isActive = true
            }
            
            infoStackView.addArrangedSubview(stack)
        }
    }
    
    private func configure() {
        changeLabel.textColor = viewModel.isPositivePercent ? .customGreen : .customRed
        titleLabel.text = viewModel.titleLabel
        priceLabel.text = viewModel.priceLabel
        changeLabel.text = viewModel.changeLabel
        marketCapLabel.text = viewModel.marketCapLabel
        supplyLabel.text = viewModel.supplyLabel
        volume24HrLabel.text = viewModel.volume24HrLabel
    }
    
    // MARK: - Objc Funcs
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
