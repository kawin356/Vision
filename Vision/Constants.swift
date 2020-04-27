//
//  Constants.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 26/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation

struct K {
    struct ReuseCell {
        static let tableViewReuseCell = "detailCell"
        static let tableViewNibName = "DetailTableViewCell"
        static let collectionImageShow = "imageCell"
        static let cameraCollectionReuseCell = "imageReuseCell"
    }
    struct Segue {
        static let selectedDetail = "goToDetail"
        static let onboardingPage = "Onboarding"
    }
    struct StoryboardID {
        static let main = "Main"
        static let tableViewMain = "ShowTableView"
        static let takeAPhoto = "TakeAPhoto"
    }
}
