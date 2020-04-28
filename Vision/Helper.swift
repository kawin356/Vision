//
//  Helper.swift
//  Trafel
//
//  Created by Kittikawin Sontinarakul on 7/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation

func delay(durationInSeconds secound: Double, completion: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + secound, execute: completion)
}

struct InternetConnection {
    static var shared = InternetConnection()
    var isConnectionNormal: Bool = true
}
