//
//  AssetsViewModel.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/24/24.
//

import Foundation

extension Double {
    static let requestDelay = 0.8
}

protocol AssetsViewModelProtocol {
    var allAssets: [Asset] { get }
    var assetsUpdated: (() -> Void)? { get set }
    func getData(page: Int)
    func filterAssets(for searchText: String)
    func nextPage()
    func resetPage()
    func getPage() -> Int
}

final class AssetsViewModel: AssetsViewModelProtocol {
    
    // MARK: - Variables
    private let networkService: NetworkService
    private var searchTimer: Timer?
    private var page = 0
    
    private(set) var allAssets: [Asset] = [] {
        didSet {
            self.assetsUpdated?()
        }
    }
    
    var assetsUpdated: (() -> Void)?
    
    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
        loadAssets(query: "", page: 0)
    }
    
    // MARK: - Private Funcs
    private func loadAssets(query: String, page: Int) {
        let queryItems = [URLQueryItem(name: API.search.rawValue, value: query), URLQueryItem(name: API.limit.rawValue, value: API.assetsLimit.rawValue), URLQueryItem(name: API.offset.rawValue, value: page.description + API.additionalNumber.rawValue)]
        var urlComps = URLComponents(string: API.baseURL.rawValue)
        urlComps?.path = API.path.rawValue
        urlComps?.queryItems = queryItems
        
        if let url = urlComps?.url {
            networkService.fetchData(from: url) { [weak self] (result: Result<AssetResponse, Error>) in
                switch result {
                case .success(let assets):
                    if page == 0 {
                        self?.allAssets = assets.data
                    } else {
                        self?.allAssets += assets.data
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Funcs
    func getData(page: Int) {
        loadAssets(query: "", page: page)
    }
    
    func filterAssets(for searchText: String) {
        searchTimer?.invalidate()
        if searchText.isEmpty {
            loadAssets(query: "", page: 0)
        } else {
            searchTimer = Timer.scheduledTimer(withTimeInterval: .requestDelay, repeats: false) { [weak self] timer in
                self?.loadAssets(query: searchText, page: 0)
            }
        }
    }
    
    func nextPage() {
        page += 1
    }
    
    func resetPage() {
        page = 0
    }
    
    func getPage() -> Int {
        return page
    }
}
