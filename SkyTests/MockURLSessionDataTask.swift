//
//  MockURLSessionDataTask.swift
//  SkyTests
//
//  Created by Tan on 2018/2/2.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var isResusmeCalled = false
    
    func resume() {
        self.isResusmeCalled = true
    }
}
