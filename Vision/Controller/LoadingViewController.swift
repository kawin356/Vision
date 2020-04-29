//
//  LoadingViewController.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 26/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(durationInSeconds: 2.0) {
            self.showInitialView()
        }
    }
    
    private func showInitialView() {
        if !UserDefaults.standard.bool(forKey: "isNotFirstTime") {
            performSegue(withIdentifier: K.Segue.onboardingPage, sender: nil)
            UserDefaults.standard.set(true, forKey: "isNotFirstTime")
        } else {
            PresentaionManager.share.show(vc: .MainController)
        }
    }
}
