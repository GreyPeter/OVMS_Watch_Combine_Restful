//
//  Location.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 12/9/2022.
//

import Foundation

struct Location: Decodable {
    var altitude: String
    var direction: String
    var drivemode: String
    var energyrecd: String
    var energyused: String
    var gpslock: String
    var invefficiency: String
    var invpower: String
    var latitude: String
    var longitude: String
    var m_msgage_l: Int
    var m_msgtime_l: String
    var power: String
    var speed: String
    var stalegps: String
    var tripmeter: String
    
    static let dummy = Location(altitude:"-0.1",direction:"41.4",drivemode:"0",energyrecd:"0.512",energyused:"0.900",gpslock:"1",invefficiency:"0",invpower:"0",latitude:"-27.708397",longitude:"153.216858",m_msgage_l:28,m_msgtime_l:"2022-03-05 23:26:47",power:"40.000",speed:"60.0",stalegps:"1",tripmeter:"50")
    
    static let initial = Location(altitude: "", direction: "", drivemode: "", energyrecd: "", energyused: "", gpslock: "", invefficiency: "", invpower: "", latitude: "", longitude: "", m_msgage_l: 0, m_msgtime_l: "", power: "", speed: "", stalegps: "", tripmeter: "")
    }
