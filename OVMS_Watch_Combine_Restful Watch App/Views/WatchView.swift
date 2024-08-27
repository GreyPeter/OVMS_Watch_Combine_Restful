//
//  ContentView.swift
//  OVMS_Watch_Combine_Restful Watch App
//
//  Created by Peter Harry on 27/8/2024.
//

import SwiftUI
import Combine
import os

enum CarMode {
    static let identifierKey = "identifier"
    case driving
    case charging
    case idle
    var identifier: String {
        switch self {
        case .driving:
            return "Driving"
        case .charging:
            return "Charging"
        case .idle:
            return "Parked"
        }
    }
}

struct WatchView: View {
    @ObservedObject var model: DefaultViewModel
    @State var userName: String = ""
    @State var password: String = ""
    @State private var oldUsername = ""
    @State var vehicleID: String = ""
    let keyChainService = KeychainService()
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: "WatchView")
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State var count = 0
    
    var body: some View {
        let socDouble = Double(model.status.soc) ?? 0.0
        let carMode = model.carMode
        let tint = carMode == .driving ? Color(.green) : Color(.clear)

        GeometryReader { watchGeo in
            VStack {
                Button(action: {
                    print("Button Pressed")
                }, label: {
                    Image("battery_000")
                        .resizable()
                        .scaledToFit()
                        .frame(width: watchGeo.size.width * 0.9, height: watchGeo.size.height * 0.3, alignment: .center)
                        .frame(width: watchGeo.size.width, height: watchGeo.size.height * 0.3, alignment: .center)
                        .overlay(ProgressBar(value:
                                                socDouble,
                                             maxValue: 100,
                                             backgroundColor: .clear,
                                             foregroundColor: color(forChargeLevel: socDouble)
                                            )
                            .frame(width: watchGeo.size.width * 0.7, height: watchGeo.size.height * 0.25)
                            .frame(width: watchGeo.size.width, height: watchGeo.size.height * 0.25)
                            .opacity(0.6)
                            .padding(0)
                        )
                        .overlay(
                            VStack {
                                Text("\(model.status.soc)%")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                Text("\(model.status.estimatedrange)\(model.status.units)")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }
                                .background(Color.clear)
                                .opacity(0.9))
                })
                .controlSize(.mini)
                .tint(tint)
                switch carMode {
                case .charging:
                    SubView(Text1: "Full", Data1: timeConvert(time: model.charge.charge_etr_full), 
                            Text2: "\(model.charge.charge_limit_soc)%", Data2: timeConvert(time: model.charge.charge_etr_soc),
                            Text3: "\(model.charge.charge_limit_range)\(model.charge.units)", Data3: timeConvert(time: model.charge.charge_etr_range),
                            Text4: "Dur", Data4: timeConvert(time: "\((Int(model.charge.chargeduration) ?? 0)/60)"),
                            Text5: "kWh", Data5: String(format:"%0.1f",(Float(model.charge.chargekwh) ?? 0.00) / 10),
                            Text6: "@ kW", Data6: model.charge.chargepower)
                case .driving:
                    SubView(Text1: "PWR", Data1: String(format:"%0.1f",(Float(model.location.power) ?? 0.00)),
                            Text2: "Trip", Data2: String(format:"%0.1f",(Float(model.location.tripmeter) ?? 0.0)/10),
                            Text3: "Rxed", Data3: String(format:"%0.2f",(Float(model.location.energyrecd) ?? 0.00)),
                            Text4: "Used", Data4: String(format:"%0.2f",(Float(model.location.energyused) ?? 0.00)),
                            Text5: "Battery", Data5: String(format:"%0.1f%°",(Float(model.status.temperature_battery) ?? 0.0)),
                            Text6: "12V", Data6: model.status.vehicle12v)
                default:
                    SubView(Text1: "Motor", Data1: "\(model.status.temperature_motor)°", 
                            Text2: "Batt", Data2: "\(model.status.temperature_battery)°",
                            Text3: "PEM", Data3: "\(model.status.temperature_pem)°",
                            Text4: "Amb", Data4: "\(model.status.temperature_ambient)°",
                            Text5: "Cabin", Data5: "\(model.status.temperature_cabin)°",
                            Text6: "12V", Data6: model.status.vehicle12v)
                }
            }
            .sheet(isPresented: $model.isPresentingSettingsView) {
                NavigationView {
                    SettingsView(userName: $userName, password: $password, vehicleID: $vehicleID)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                             Button("Dismiss") {
                             model.isPresentingSettingsView = false
                             oldUsername = userName
                             }.font(.footnote)
                             }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    WatchView.logger.debug("User: \(userName) Old: \(oldUsername) Password: \(password) Vehicle: \(vehicleID)")
                                    //print("User: \(userName) Old: \(oldUsername) Password: \(password) Vehicle: \(vehicleID)")
                                    // Check if userName has changed.
                                    //If so update delete old password entry for username
                                    if userName != oldUsername {
                                        do {
                                            try keyChainService.deletePasswordFor(for:oldUsername)
                                        } catch {
                                            print(error)
                                        }
                                        //Save new password for updataed userName
                                        keyChainService.save(password, for: userName)
                                        userName = userName
                                    } else {
                                        // userName has not changed so only the password remains
                                        if let oldPassword = keyChainService.retrievePassword(for: userName)
                                        {
                                            if password != oldPassword {
                                                do {
                                                    try keyChainService.updatePasswordFor(user: userName, password: password)
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        } else {
                                            keyChainService.save(password, for: userName)
                                        }
                                    }
                                    model.isPresentingSettingsView = false
                                    let defaults = UserDefaults.standard
                                    defaults.set(userName, forKey: "username")
                                    defaults.set(vehicleID, forKey: "vehicle")
                                    model.updatePassword(password: password, user: userName, vehicle: vehicleID)
                                    model.initCookie()
                                }.font(.footnote)
                            }
                        }
                }
            }
        }
        .onReceive(timer) {_ in
            count += 1
            if count > 5 {
                count = 0
                model.initCookie()
            } else {
                if let myCookie = keyChainService.retrievePassword(for: "Cookie") {
                    model.getStatus(cookie: myCookie)
                    model.getCharge(cookie: myCookie)
                    model.getLocation(cookie: myCookie)
                }
            }
            print("Count = \(count)")
        }
    }
}

#Preview {
    WatchView(model: DefaultViewModel.shared)
}
