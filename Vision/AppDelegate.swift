//
//  AppDelegate.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 25/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var reachability: Reachability!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataController.shared.load()
        
        createNotificationToCheckConnection()
        
        return true
    }
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
            if reachability.connection == .wifi || reachability.connection == .cellular {
                InternetConnection.shared.isConnectionNormal = true
            }
        } else {
            InternetConnection.shared.isConnectionNormal = false
            showAlert()
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: nil, message: "Please Check Internet Connection!!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func createNotificationToCheckConnection() {
        do {
            try reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
        }
    }
}

