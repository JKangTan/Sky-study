//
//  WeekWeatherTableViewCell.swift
//  Sky
//
//  Created by Tan on 2018/2/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell {

    static let reuseIdentifier = "WeekWeatherCell"
    
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
