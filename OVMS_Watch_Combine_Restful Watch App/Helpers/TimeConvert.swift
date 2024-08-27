//
//  TimeConvert.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 12/9/2022.
//

import Foundation

func timeConvert(time: String) -> String {
    guard let intTime = Int(time) else { return "--:--" }
    if intTime <= 0 {
        return "--:--"
    }
    return String(format: "%d:%02d",(Int(time) ?? 0)/60,(Int(time) ?? 0)%60)
}
