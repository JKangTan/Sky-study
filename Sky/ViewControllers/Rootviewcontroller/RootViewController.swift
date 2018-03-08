//
//  ViewController.swift
//  Sky
//
//  Created by Mars on 28/09/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    var currentWeatherController: CurrentWeatherViewController!
    private let segueCurrentWather = "segueCurrentWeather"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identify = segue.identifier else {
            return
        }
        switch identify {
        case segueCurrentWather:
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination")
            }
            destination.delegate = self
            destination.viewModel = CurrentWeatherViewModel()
            currentWeatherController = destination
        default:
            break
        }
    }
    
    private var currentLocation: CLLocation? {
        didSet {
            // 获取城市名称 和 天气
            fetchCity()
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon, completion: {
            response, error in
            if let error = error {
                dump(error)
            }
            else if let response = response {
                // Notify CurrentWeather
                self.currentWeatherController.viewModel?.weather = response
            }
        })
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // 通知 CurrentWeatherController
                let l = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
               self.currentWeatherController.viewModel?.location = l
            }
        })
    }
    
    private lazy var locatoinManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 100
        manager.desiredAccuracy = 100
        return manager
    }()
    
    private func requestLocation() {
        locatoinManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locatoinManager.requestLocation()
        }
        else { //请求授权
            locatoinManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        // 请求位置信息
        requestLocation()
    }

    func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: Notification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
}

extension RootViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil //获取到后取消监听
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}

extension RootViewController: CurrentWeatherViewControllerDelegate {
    func settingsButtonPressed(controller: CurrentWeatherViewController) {
        print("setting")
    }
    
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        print("location")
    }
    
}









































