//
//  Slide.swift
//  Trafel
//
//  Created by Kittikawin Sontinarakul on 7/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation

struct Slide {
    let imageName: String
    let title: String
    let description: String
    
    static let collection: [Slide] = [
        Slide(imageName: "imSlide1", title: "OCR", description: "Optical Character Recognition (OCR)"),
        Slide(imageName: "imSlide2", title: "Detect Text in Image", description: "Take a Photo and Done!! "),
        Slide(imageName: "imSlide3", title: "Easy to use, Easy to shared", description: "Copy text and shared to people.")
    ]
}
