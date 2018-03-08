//
//  CurrentWeatherUITests.swift
//  SkyUITests
//
//  Created by Tan on 2018/2/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import XCTest

class CurrentWeatherUITests: XCTestCase {
        
    // 获取当前 APP 运行实例
    let app = XCUIApplication()
    
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["fakeJSON"] = """
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
        """
        app.launch()
        //设计测试用例
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_location_button_exists() {
        let locationBtn = app.buttons["locationBtn"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: locationBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(locationBtn.exists)
    }
    
    
}
