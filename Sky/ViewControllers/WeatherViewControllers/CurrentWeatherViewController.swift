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
    
    var viewModel: CurrentWeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        activityIndicatorView.startAnimating()
        
        if let vm = viewModel, vm.isUpdateReady{
            updateWeatherContainer(with: vm)
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "获取位置或天气失败"
        }
    }
    
    func updateWeatherContainer(with vm: CurrentWeatherViewModel){
        weatherContainerView.isHidden = false
        
        //格式化数据
        // 设置位置
        locationLabel.text = vm.city
        temperatureLabel.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
        humidityLabel.text = vm.humidity
        summaryLabel.text = vm.summary
        dateLabel.text = vm.date

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
