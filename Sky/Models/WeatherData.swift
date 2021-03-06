//
//  WeatherData.swift
//  Sky
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

struct WeatherData: Codable {

    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
}

//遵循 Equatable 协议才能被 equal 方法比较
extension WeatherData.CurrentWeather: Equatable{
    static func ==(
        lhs: WeatherData.CurrentWeather,
        rhs: WeatherData.CurrentWeather) -> Bool {
        
        return lhs.time == rhs.time &&
        lhs.summary == rhs.summary &&
        lhs.icon == rhs.icon &&
        lhs.temperature == rhs.temperature &&
        lhs.humidity == rhs.humidity
    }
}

extension WeatherData: Equatable{
    static func ==(
        lhs: WeatherData,
        rhs: WeatherData) -> Bool {
        
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.currently == rhs.currently
    }
}
