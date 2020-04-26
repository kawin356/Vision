//
//  GoogleAPI.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 25/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class GoogleAPI {
    
    
    enum Endpoint {
        static let endPoint = "https://vision.googleapis.com/v1/images:annotate"
        static let apiKey = "AIzaSyD-IAmWA0NKGNarU0Bxtz-esSp47V5phBo"
        
        case detectImage
        
        var stringValue: String {
            switch self {
            case .detectImage: return "\(Endpoint.endPoint)?key=\(Endpoint.apiKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func base64EncodeImage(_ image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    class func taskDetect(form image: UIImage, completion: @escaping (Results?) -> Void) {
        guard let base64Image = base64EncodeImage(image) else {
            print("Error while base64 encoding image")
            completion(nil)
            return
        }
        let parameters: Parameters = [
            "requests": [
                [
                    "image": [
                        "content": base64Image
                    ],
                    "features": [
                        [
                            "type": "TEXT_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
        ]
        AF.request(
            Endpoint.detectImage.url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            .responseData { response in
                
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                do {
                    //print(String(data: data, encoding: .utf8)!)
                let object = try JSONDecoder().decode(GoogleResponse.self, from: data)
                    completion(object.responses[0])
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
    
    
}

