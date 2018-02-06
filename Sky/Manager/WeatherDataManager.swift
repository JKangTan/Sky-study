//
//  WeatherDataManager.swift
//  Sky
//
//  Created by Tan on 2018/2/1.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

internal class DarkSkyURLSession: URLSessionProtocol {
    func dataTask(with Request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return DarkSkyURLSessionDataTask(request: Request, completion: completionHandler)
    }
}

internal class DarkSkyURLSessionDataTask: URLSessionDataTaskProtocol {
    private let  requst: URLRequest
    private let completion: DataTaskHandler
    
    init(request: URLRequest, completion: @escaping DataTaskHandler) {
        self.requst = request
        self.completion = completion
    }
    
    func resume() {
        //访问环境变量
        let json = ProcessInfo.processInfo.environment["fakeJSON"]
        if let json = json {
            let response = HTTPURLResponse(
                url: requst.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            let data = json.data(using: .utf8)!
            
            completion(data, response, nil)
        }
    }
}

internal struct Config {
    private static func isUITesting() -> Bool {
       return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    
    static var urlSession: URLSessionProtocol = {
        if isUITesting() {
            //MOCK 系统的 urlSession 
            return DarkSkyURLSession()
        }
        else {
            return URLSession.shared
        }
    }()
}

enum DataManagerError: Error {
    case failedRequest
    case unvalidResponse
    case unknown
}

final class WeatherDataManager {
    internal let  baseURL: URL
    internal let  urlSession: URLSessionProtocol
    internal init (baseURL: URL, urlSession: URLSessionProtocol){
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    //创建单利对象
    static let shared = WeatherDataManager(baseURL: API.authenticatedURL, urlSession: Config.urlSession)
    // 异步回调函数 返回 model 对象和错误信息
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    func weatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler) {
        let url = baseURL.appendingPathComponent("\(latitude),\(longitude)")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        self.urlSession.dataTask(with: request, completionHandler: {
            (data, response, error) in
//            DispatchQueue.main.async {  //在设计上的决策推迟到你真正需要的时候
                self.didFinishGettingWeatherData(data: data, response:response, error: error, completion: completion)
//            }
        }).resume()
        
    }
    
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        }
        else  if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    //按照 weatherData 模型解析 data 并返回
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(weatherData, nil)
                }
                catch {
                    completion(nil, .unvalidResponse)
                }
            }
            else {
                completion(nil, .failedRequest)
            }
        }
        else {
            completion(nil, .unknown)
        }
    }
}
