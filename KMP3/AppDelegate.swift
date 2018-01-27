//
//  AppDelegate.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewModel = FeedViewModel(networkService: NetworkService())
        let songFeedVC = FeedViewController(viewModel: viewModel)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.rootViewController = songFeedVC
        window!.makeKeyAndVisible()
        
        return true
    }
}

