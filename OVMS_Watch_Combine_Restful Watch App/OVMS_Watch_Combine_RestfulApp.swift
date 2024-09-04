//
//  OVMS_Watch_Combine_RestfulApp.swift
//  OVMS_Watch_Combine_Restful Watch App
//
//  Created by Peter Harry on 27/8/2024.
//

import SwiftUI

@main
struct OVMS_Watch_Combine_Restful_Watch_AppApp: App {
	@StateObject private var model = DefaultViewModel.shared
	//@WKExtensionDelegateAdaptor private var extensionDelegate: WKDelegate
    var body: some Scene {
        WindowGroup {
			WatchView(model: model)
        }
    }
}

/* TODO:
 
 When charge is started status.charging > 0 so getCharge() started but when charge stopped status.charging still > 0
 Need to check if status.charging has changed from 0 to 12 - Charge Started
 Need to check if charge.charging has changed from 12 to 0 - Charge Stopped
 Add 2 more cases to CarMode - Started and Stopped
 
*/
