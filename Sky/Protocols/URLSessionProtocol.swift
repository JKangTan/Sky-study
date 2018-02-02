//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias dataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask (with Request: URLRequest, completionHandler: @escaping dataTaskHandler) -> URLSessionDataTaskProtocol
}
