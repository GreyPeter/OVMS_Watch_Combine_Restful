//
//  WKDelegate.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 12/9/2022.
//


// Probably not needed should probably remove this file
import Foundation
import os
import WatchKit

class WKDelegate: NSObject, WKExtensionDelegate {
    
    private var model = DefaultViewModel.shared
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: "Delegate")
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        WKDelegate.logger.debug("Finished Launching")
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        WKDelegate.logger.debug("Became Active")
        if !model.isPresentingSettingsView {
            //model.getCharge()
            //model.getStatus()
            //model.getLocation()
        }
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        WKDelegate.logger.debug("Resign Active")
    }
}
