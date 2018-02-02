//
//  Double.swift
//  Sky
//
//  Created by Tan on 2018/2/2.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

extension Double
{
    func toCelcius() -> Double{
        return (self - 32.0) / 1.8
    }
}
