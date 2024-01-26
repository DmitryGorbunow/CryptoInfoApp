//
//  ViewController.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/23/24.
//

import UIKit

private enum Constants {
    static let opacity: Float = 0.7
    static let alpha5: CGFloat = 0.5
    static let alpha1: CGFloat = 0.1
    static let kern: CGFloat = 0.48
    static let textFieldCornerRadius: CGFloat = 12
    static let buttonSize: CGFloat = 40
    static let heightForRowAt: CGFloat = 72
}

class AssetsViewController: UIViewController {
    
    // MARK: - Variables
    private var viewModel: AssetsViewModelProtocol
    private var searchBarIsActive = false
    
    // MARK: - UI Components
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.searchTextField.tintColor = .white
        searchBar.tintColor = .white.withAlphaComponent(Constants.alpha5)
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.placeholder = StringValues.searchBySymbolOrName
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.layer.cornerRadius = Constants.textFieldCornerRadius
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.borderColor = UIColor.white.withAlphaComponent(Constants.alpha1).cgColor
        return searchBar
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.lExt
        label.attributedText = NSMutableAttributedString(string: StringValues.trendingCoins, attributes: [NSAttributedString.Key.kern: Constants.kern])
        return label
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: Constants.buttonSize, height: Constants.buttonSize)
        button.layer.cornerRadius = Constants.textFieldCornerRadius
        button.layer.borderWidth = 1
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.withAlphaComponent(Constants.alpha1).cgColor
        return button
        
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bg
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let noResultslabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        label.text = StringValues.noResults
        label.font = Fonts.l
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let assetsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(AssetsTableViewCell.self, forCellReuseIdentifier: AssetsTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initializer
    init(viewModel: AssetsViewModelProtocol) {
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
        configure()
    }
    
    // MARK: - Private Funcs
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(assetsTableView)
        view.addSubview(activityIndicator)
        view.addSubview(noResultslabel)
        setupNavBar()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            assetsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            assetsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            assetsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            assetsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noResultslabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultslabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset48)
        ])
    }
    
    private func configure() {
        assetsTableView.dataSource = self
        assetsTableView.delegate = self
        searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        activityIndicator.startAnimating()
        assetsTableView.refreshControl = refreshControl
        viewModel.assetsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.assetsTableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                self?.spinner.stopAnimating()
                
                if let assetsCount = self?.viewModel.allAssets.count {
                    self?.noResultslabel.isHidden = assetsCount > 0 ? true : false
                    print("\(assetsCount) assets in array")
                }
            }
        }
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleBarButtonItem
    }
    
    // MARK: - Objc Funcs
    @objc private func refreshData() {
        searchBarIsActive ? viewModel.filterAssets(for: searchBar.text ?? "") : viewModel.getData(page: 0)
    }
    
    @objc func searchButtonTapped() {
        navigationItem.leftBarButtonItem = .none
        navigationItem.rightBarButtonItem = .none
        navigationItem.titleView = searchBar
    }
}

// MARK: - UITableViewDataSource
extension AssetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.allAssets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = assetsTableView.dequeueReusableCell(withIdentifier: AssetsTableViewCell.identifier, for: indexPath) as? AssetsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.allAssets[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AssetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let asset = viewModel.allAssets[indexPath.row]
        let vm = DetailsAssetsViewModel(asset: asset)
        let vc = DetailsAssetsViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !searchBarIsActive else { return }
        if indexPath.row  == viewModel.allAssets.count - 1 {
            viewModel.nextPage()
            viewModel.getData(page: viewModel.getPage())
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.assetsTableView.tableFooterView = spinner
            self.assetsTableView.tableFooterView?.isHidden = false
        }
    }
}

// MARK: - UISearchBarDelegate
extension AssetsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        viewModel.resetPage()
        searchBarIsActive = searchText.isEmpty ? false : true
        viewModel.filterAssets(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarIsActive = false
        searchBar.text = .none
        viewModel.filterAssets(for: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        navigationItem.titleView = .none
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleBarButtonItem
    }
}



