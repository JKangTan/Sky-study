//
//  MockURLSession.swift
//  SkyTests
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

@testable import Sky

class MockURLSession: URLSessionProtocol {
    var responseData: Data?
    var responseHandle: HTTPURLResponse?
    var responseError: Error?
    
    var sessionDataTask = MockURLSessionDataTask()
    
    func dataTask(with Request: URLRequest, completionHandler: @escaping URLSessionProtocol.dataTaskHandler) -> URLSessionDataTaskProtocol {
        //模拟直接返回
        completionHandler(responseData, responseHandle, responseError)
        return sessionDataTask
    }
}
