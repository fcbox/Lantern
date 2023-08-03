//
//  AppDelegate.swift
//  Example
//
//  Created by JiongXing on 2019/11/26.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        let vc  = HomeViewController()
        let nav = UINavigationController.init(rootViewController:vc)
        self.window?.rootViewController =  nav
        configNavigationBar()
        return true
    }
    
    private func configNavigationBar() {
        let bar = UINavigationBar.appearance()
        bar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                                   NSAttributedString.Key.foregroundColor: UIColor.black]
        // 适配dark 返回按钮刷新用图片有问题，暂用颜色方式代替
        bar.tintColor = UIColor.black
        bar.shadowImage = UIImage()

        let item = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.black]
        item.setTitleTextAttributes(attr, for: .normal)
        item.setTitleTextAttributes(attr, for: .highlighted)
    }
}
