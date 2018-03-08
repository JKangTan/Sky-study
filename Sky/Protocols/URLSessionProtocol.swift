//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {

    
    func dataTask (with Request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}
