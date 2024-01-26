//
//  SceneDelegate.swift
//  CryptoInfo
//
//  Created by Dmitry Gorbunow on 1/23/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let networkService = NetworkService()
        let vm = AssetsViewModel(networkService: networkService)
        let vc = AssetsViewController(viewModel: vm)
        window.rootViewController = UINavigationController(rootViewController: vc)
        self.window = window
        window.makeKeyAndVisible()
    }
}

