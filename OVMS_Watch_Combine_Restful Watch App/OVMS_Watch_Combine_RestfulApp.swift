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
 

*/
