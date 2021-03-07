//
//  AppDelegate.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 21.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = StocksListViewController()
        let networkManager = NetworkManager()
        let stocksInfoService = StocksInfoService(networkManager: networkManager)
        let presener = StocksListPresenter(view: rootViewController, stocksInfoService: stocksInfoService)
        rootViewController.presenter = presener

        let nc = UINavigationController(rootViewController: rootViewController)

        window?.rootViewController = nc
        window?.makeKeyAndVisible()

        return true
    }

}
