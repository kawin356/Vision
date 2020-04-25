//
//  GoogleResponse.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 25/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation
import UIKit

struct Vertex: Codable {
    let x: Int?
    let y: Int?
}

struct BoundingBox: Codable {
    let vertices: [Vertex]
}

struct Annotation: Codable {
    let description: String
    let boundingPoly: BoundingBox
}

struct Full: Codable {
    let text: String
}

struct Results: Codable {
    let textAnnotations: [Annotation]
    let fullTextAnnotation: Full
}

struct GoogleResponse: Codable {
    let responses: [Results]
}
