//
//  DefaultViewModel.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 11/9/2022.
//

import Foundation
import Combine
import os

class DefaultViewModel: ObservableObject {
    static let shared = DefaultViewModel()
    @Published var status = Status.initial
    @Published var charge = Charge.initial
    @Published var location = Location.initial
    @Published var vehicles = Vehicle.dummy
    var carMode: CarMode {
        get {
            if status.charging > 0 {
                return .charging
            } else if status.caron > 0 {
                return .driving
            }
            return .idle
        }
    }
    var vehInfo = VehicleInfo.initial
    private var cancellable: AnyCancellable?
    private var cancellable1: AnyCancellable?
    private var cancellable2: AnyCancellable?
    private var cancellable3: AnyCancellable?
    private var cancellable4: AnyCancellable?
    public var isPresentingSettingsView: Bool

    private var user = ""
    private var password = ""
    private var vehicleID = ""
    var connected = false

    let keyChainService = KeychainService()
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: "ViewModel")
    
    init() {
        self.isPresentingSettingsView = false
        user = getUsername()
        password = getPassword()
        vehicleID = getVehicleID()
        if(user == "" || password == "" || vehicleID == "") {
            self.isPresentingSettingsView = true
        } else {
            Self.logger.trace("Username = \(self.user) Password = \(self.password) Vehicle: = \(self.vehicleID)")
            initCookie()
        }
    }
    
    func connectVehicle(cookie: String) {
        self.cancellable4 = Webservice().getVehicle(cookie: cookie, vehicle: vehicleID)
            .print()
            .catch{ _ in Just(self.vehInfo)}
            .assign(to: \.vehInfo, on: self)
        connected = true
    }
    
    func getStatus(cookie: String) {
        self.cancellable = Webservice().getStatus(cookie: cookie, vehicle: vehicleID)
            .print()
            .catch{ _ in Just(self.status)}
            .assign(to: \.status, on: self)
    }

    func getCharge(cookie: String) {
        self.cancellable1 = Webservice().getCharge(cookie: cookie, vehicle: vehicleID)
            .print()
            .catch{ _ in Just(self.charge)}
            .assign(to: \.charge, on: self)
    }

    func getLocation(cookie: String) {
        self.cancellable2 = Webservice().getLocation(cookie: cookie, vehicle: vehicleID)
            .print()
            .catch{ _ in Just(self.location)}
            .assign(to: \.location, on: self)
    }
    
    func getVehicles(cookie: String) {
        self.cancellable3 = Webservice().getVehicles(cookie: cookie)
            .print()
            .catch{ _ in Just(self.vehicles)}
            .assign(to: \.vehicles, on: self)
    }
    
    func getUsername() -> String {
        let defaults = UserDefaults.standard
        guard let usr = defaults.string(forKey: "username") else {
            self.isPresentingSettingsView = true
            return ""
        }
            return usr
    }
    
    func getVehicleID() -> String {
        let defaults = UserDefaults.standard
        guard let vehicle = defaults.string(forKey: "vehicle") else {
            self.isPresentingSettingsView = true
            return ""
        }
            return vehicle
    }
    
    func getPassword() -> String {
            
            guard let pwd = keyChainService.retrievePassword(for: user) else {
                self.isPresentingSettingsView = true
                return ""
            }
                return pwd
    }
    
    func updatePassword(password: String, user: String, vehicle: String) {
        self.password = password
        self.user = user
        self.vehicleID = vehicle
    }

    func initCookie() {
        password = getPassword()
        vehicleID = getVehicleID()
        if(user == "" || password == "" || vehicleID == "") {
            DefaultViewModel.logger.error("Could not get Username or Password")
        } else {
            guard let url = URL(string: "https://api.openvehicles.com:6869/api/cookie/?username=\(getUsername())&password=\(getPassword())")
            else { fatalError("Invalid URL") }
            let urlSession = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                }
                //            if let data = data {
                //                print(data)
                //            }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        print("response = \(String(describing: response))")
                        if let newCookie = httpStatus.value(forHTTPHeaderField: "Set-Cookie") {
                            DefaultViewModel.logger.info("New Cookie: \(newCookie)")
                            if self.keyChainService.retrievePassword(for: "Cookie") != nil {
                                do {
                                    try self.keyChainService.updatePasswordFor(user: "Cookie", password: newCookie)
                                } catch {
                                    DefaultViewModel.logger.error("Could not save Cookie")
                                }
                            } else {
                                self.keyChainService.save(newCookie, for: "Cookie")
                            }
                            self.connectVehicle(cookie: newCookie)
                            //                        self.getVehicles(cookie: newCookie)
                            self.getStatus(cookie: newCookie)
                            self.getCharge(cookie: newCookie)
                            self.getLocation(cookie: newCookie)
                            
                        }
                    } else {
                        // check for http errors
                        DefaultViewModel.logger.error("InitCookie - statusCode should be 200, but is \(httpStatus.statusCode)")
                        DefaultViewModel.logger.error("response = \(String(describing: response))")
                    }
                }
            }
            urlSession.resume()
        }
    }
}
