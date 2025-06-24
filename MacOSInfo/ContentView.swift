//
//  ContentView.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var osInfo = SystemInfo()
    
    @StateObject private var core0 = UsageHistory()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 6){
            Text("MacOSInfo - Viewer")
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
            Text("* macOS Version: \(osInfo.macOSVersion)")
            Text("* Model Identifier: \(osInfo.modelIdentifier)")
            Text("* CPU Name: \(osInfo.cpuName)")
            Text("* Total CPUs: \(osInfo.totalCpuCount)")
            Text("* Available CPUs: \(osInfo.availableCpuCount)")
            Text("* RAM: \(osInfo.totalRAM)")
            Text("* Uptime: \(osInfo.uptime)")
            
            Spacer()
            
            Text("* Thermal State: \(osInfo.thermalState)")
            
            Spacer()
            
            MiniGraphView(label: "Core 0", history: core0)
        }
        .padding()
        .frame(width: 420, height: 340)
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                let simulatedUsage = Double.random(in: 0.1...0.9)
                core0.add(usage: simulatedUsage)
            }
        }
    }
}

#Preview {
    ContentView()
}
