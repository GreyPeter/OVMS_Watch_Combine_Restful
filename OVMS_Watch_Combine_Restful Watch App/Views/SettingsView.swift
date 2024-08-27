//
//  SettingsView.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 12/9/2022.
//

import SwiftUI

struct SettingsView: View {
    @Binding var userName: String
    @Binding var password: String
    @Binding var vehicleID: String
    var body: some View {
        VStack {
          Spacer()
          TextField("OVMS Username", text: $userName)
          SecureField("Password", text: $password)
          SecureField("Vehicle ID", text: $vehicleID)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userName: .constant(""), password: .constant(""), vehicleID: .constant(""))
    }
}
