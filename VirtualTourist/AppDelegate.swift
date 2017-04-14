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
    
    // MARK: Background Load

    func backgroundLoad() {
        
        stack.performBackgroundBatchOperation { (workerContext) in
            
//            for i in 1...100 {
//                let nb = Notebook(name: "Background notebook \(i)", context: workerContext)
//                
//                for _ in 1...100{
//                    let note = Note(text: "The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother's keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who would attempt to poison and destroy My brothers. And you will know My name is the Lord when I lay My vengeance upon thee.", context: workerContext)
//                    note.notebook = nb
//                }
//            }
            print("==== finished background operation ====")
        }
    }


    // MARK: UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Start Autosaving
        stack.autoSave(60)
        
        // add new objects in the background
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(5 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.backgroundLoad()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        if let mapViewController = mapViewController {
            mapViewController.saveSettings()
        }
        
        stack.save()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if let mapViewController = mapViewController {
            mapViewController.saveSettings()
        }
        
        stack.save()
    }

}

