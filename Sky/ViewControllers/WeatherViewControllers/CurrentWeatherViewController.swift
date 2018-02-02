//
//  CurrentWeatherViewController.swift
//  Sky
//
//  Created by Tan on 2018/2/2.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

protocol CurrentWeatherViewControllerDelegate: class {
    func locationButtonPressed(controller: CurrentWeatherViewController)
    func settingsButtonPressed(controller: CurrentWeatherViewController)
}

class CurrentWeatherViewController: WeatherViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: CurrentWeatherViewControllerDelegate?
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        delegate?.settingsButtonPressed(controller: self)
    }
    
    var now: WeatherData? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    var location: Location? {
        didSet {
             self.updateView()
        }
    }
    
    func updateView() {
        activityIndicatorView.startAnimating()
        
        if let now = now, let location = location {
            updateWeatherContainer(with: now, at: location)
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "获取位置或天气失败"
        }
    }
    
    func updateWeatherContainer(with data: WeatherData, at location: Location){
        weatherContainerView.isHidden = false
        
        //格式化数据
        // 设置位置
        locationLabel.text = location.name
        temperatureLabel.text = String(
            format: "%.1f ℃",
            data.currently.temperature.toCelcius())
        weatherIcon.image = weatherIcon(of: data.currently.icon)
        humidityLabel.text = String(
            format: "%.1f",
            data.currently.humidity)
        summaryLabel.text = data.currently.summary
        
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy年MM月dd日"
        dateLabel.text = formatter.string(from: (now?.currently.time)!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
