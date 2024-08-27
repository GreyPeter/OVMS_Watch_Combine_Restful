//
//  DefaultView.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 11/9/2022.
//

import SwiftUI
import os

struct DefaultView: View {
    @ObservedObject private var model = DefaultViewModel()
    let logger = Logger(subsystem:
                            "au.com.prhenterprises.OVMS-Watch",
                        category: "DefaultView")
    var body: some View {
      let socDouble = 50.0
        GeometryReader { watchGeo in
            VStack {
                //Text(vehicles[0].id)
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
                            Text("\(model.status.soc)%      I")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Text("\(model.status.estimatedrange)\(model.status.units)")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                            .background(Color.clear)
                            .opacity(0.9))
            }
        }
    }
}

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
