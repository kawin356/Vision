//
//  Image.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 25/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation

struct ImageRequest: Codable {
    let requests : [Detail]
}

struct Detail: Codable {
    let image: Content
    let features: Feature
}

struct Content: Codable {
    let content: String
}

struct Feature: Codable {
    let features: [Type]
}

struct Type: Codable {
    let type: String
}


/*
{
  "requests": [
    {
      "image": {
        "content": "base64-encoded-image"
      },
      "features": [
        {
          "type": "TEXT_DETECTION"
        }
      ]
    }
  ]
}
*/
