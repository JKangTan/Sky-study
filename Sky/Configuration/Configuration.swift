//
//  Configuration.swift
//  Sky
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

struct API {
    static let key = "dad355ca15eac2cfd5bc41e5aa858754"
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
    
}
