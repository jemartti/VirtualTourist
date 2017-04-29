//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/8/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mapViewController: VTMapViewController?
    let stack = CoreDataStack(modelName: "Model")!
    
    // MARK: UIApplicationDelegate
    
    func applicationWillResignActive(_ application: UIApplication) {
        saveState()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveState()
    }
    
    func saveState() {
        if let mapViewController = mapViewController {
            mapViewController.saveSettings()
        }
        
        stack.save()
    }
}
