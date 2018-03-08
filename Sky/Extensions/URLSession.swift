//
//  URLSession.swift
//  Sky
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(with Request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: Request, completionHandler: completionHandler) as URLSessionDataTask as URLSessionDataTaskProtocol
    }
}

