//
//  PresentationManager.swift
//  Trafel
//
//  Created by Kittikawin Sontinarakul on 7/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class PresentaionManager {
    static let share = PresentaionManager()
    
    private init() {}
    
    enum VC {
        case MainController
        case CameraController
    }
    
    func show (vc: VC){
        var viewContoller: UIViewController
        
        switch vc {
        case .MainController:
            viewContoller = UIStoryboard(name: K.StoryboardID.main, bundle: nil)
                .instantiateViewController(identifier: K.StoryboardID.tableViewMain)
        case .CameraController:
            viewContoller = UIStoryboard(name: K.StoryboardID.main, bundle: nil)
                .instantiateViewController(identifier: K.StoryboardID.takeAPhoto)
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window {
            window.rootViewController = viewContoller
            UIView.transition(with: window, duration: 0.25,
            options: .transitionCrossDissolve,
            animations: nil, completion: nil)
        }
    }
}

