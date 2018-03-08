//
//  WeatherDataManagerTest.swift
//  SkyTests
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//  测试用例

import XCTest
@testable import Sky

class WeatherDataManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_weatherDataAt_starts_the_session() {
        let session = MockURLSession() //Mock掉系统 API 或者第三方框架对功能的影响
        let dataTask = MockURLSessionDataTask()
        
        session.sessionDataTask = dataTask
        
        let manager = WeatherDataManager(baseURL: URL(string: "https://darksky.net")!, urlSession: session)
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: {_, _ in})
        
        //每个单元测试都应该只测试一个功能 这里只测试了 task 的 resume() 是否被正确调用了
        XCTAssert(session.sessionDataTask.isResusmeCalled)
    }
    
    // 测试异步回调  mock 内改为同步返回
    func test_weatherDataAt_handle_invalie_request(){
        let session = MockURLSession()
        session.responseError = NSError(domain: "Invalid Request", code: 100, userInfo: nil)
        
        let manager = WeatherDataManager(baseURL: URL(string: "https://api.darksky.net")!, urlSession: session)
        
        
        var error: DataManagerError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: {(_, e) in error = e})
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    // 错误的请求
    func test_weatherDataAt_reponseCode_not_200(){
        let session = MockURLSession()
        session.responseHandle = HTTPURLResponse(url: URL(string: "https://api.darksky.net")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        
        let manager = WeatherDataManager(baseURL: URL(string: "https://api.darksky.net")!, urlSession: session)
        
        
        var error: DataManagerError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: {(_, e) in error = e})
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    //正确的请求 错误的返回数据
    func test_weatherDataAt_handle_invalid_response(){
        let session = MockURLSession()
        session.responseHandle = HTTPURLResponse(url: URL(string: "https://api.darksky.net")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = "{".data(using: .utf8)! //错误的 data
        session.responseData = data
        
        let manager = WeatherDataManager(baseURL: URL(string: "https://api.darksky.net")!, urlSession: session)
        
        
        var error: DataManagerError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: {(_, e) in error = e})
        XCTAssertEqual(error, DataManagerError.unvalidResponse)
    }
    //正确的请求
    func test_weatherDataAt_handle_response_decode(){
        let session = MockURLSession()
        session.responseHandle = HTTPURLResponse(url: URL(string: "https://api.darksky.net")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = """
        {
            "latitude":37.8267,
            "longitude":-122.4233,
            "currently":{
                "time":1517542568,
                "summary":"Clear",
                "icon":"clear-night",
                "temperature":62.14,
                "humidity":0.54
                }
        }
        """.data(using: .utf8)! //正确的 data
        session.responseData = data
        
        let manager = WeatherDataManager(baseURL: URL(string: "https://api.darksky.net")!, urlSession: session)
        
        
        var  decoder: WeatherData? = nil
        manager.weatherDataAt(latitude: 37.8267, longitude: -122.4233, completion: {(d, _) in decoder = d})
        
        //模拟解析结果
        let expected = WeatherData(
            latitude: 37.8267,
            longitude: -122.4233,
            currently: WeatherData.CurrentWeather(
                time: Date(timeIntervalSince1970: 1517542568),
                summary: "Clear",
                icon: "clear-night",
                temperature: 62.14,
                humidity: 0.54
            )
        )
        
        XCTAssertEqual(decoder, expected)
    }
}




















