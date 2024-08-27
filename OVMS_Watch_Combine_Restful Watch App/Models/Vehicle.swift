//
//  Vehicle.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 12/9/2022.
//

import Foundation

struct Vehicle: Decodable, Identifiable {
    var id: String
    var v_apps_connected: Int
    var v_btcs_connected: Int
    var v_net_connected: Int
    
    static let initial: [Vehicle] = [Vehicle(id: "", v_apps_connected: 0, v_btcs_connected: 0, v_net_connected: 0)]
    
    static let dummy: [Vehicle] =
    [Vehicle(id: "No Password", v_apps_connected: 0, v_btcs_connected: 0, v_net_connected: 1),
     Vehicle(id: "Home", v_apps_connected: 0, v_btcs_connected: 0, v_net_connected: 1)]
}
struct VehicleInfo: Decodable {
    var v_apps_connected: Int
    var v_btcs_connected: Int
    var v_first_peer: Int
    var v_net_connected: Int
    static let initial: VehicleInfo = VehicleInfo(v_apps_connected: 0, v_btcs_connected: 0, v_first_peer: 0, v_net_connected: 0)
}
