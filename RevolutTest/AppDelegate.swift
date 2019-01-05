//
//  AppDelegate.swift
//  RevolutTest
//
//  Created by Артмеий Шлесберг on 26/12/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootController = UINavigationController(rootViewController: ViewController(viewModel: BaseRateCellModelsSource(currencySource: CurrencySourceFromAPI())))
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        return true
    }

}

