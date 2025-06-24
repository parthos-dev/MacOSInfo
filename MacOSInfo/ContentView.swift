//
//  ContentView.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var osInfo = SystemInfo()
    
    @StateObject private var monitor = MultiCoreMonitor()
    
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 6){
                Text("System Info")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 4)
                
                Group {
                    Text("* macOS Version: \(osInfo.macOSVersion)")
                    Text("* Model Identifier: \(osInfo.modelIdentifier)")
                    Text("* CPU Name: \(osInfo.cpuName)")
                    Text("* Total CPUs: \(osInfo.totalCpuCount)")
                    Text("* Available CPUs: \(osInfo.availableCpuCount)")
                    Text("* RAM: \(osInfo.totalRAM)")
                    Divider()
                    Text("* Uptime: \(osInfo.uptime)")
                    Text("* Thermal State: \(osInfo.thermalState)")
                    
                }
                .font(.callout)
                
                Divider()
                
                Text("Per-Core CPU Usage")
                    .font(.headline)
                    .bold()
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(Array(monitor.coreHistories.enumerated()), id: \.offset) { index, coreHistory in
                        VStack(spacing: 2) {
                            MiniGraphView(label: "Core \(index)", history: coreHistory)
                        }
                        .frame(width: 140, height: 80)
                        .background(Color(NSColor.windowBackgroundColor))
                        .cornerRadius(8)
                        .shadow(radius: 1)
                    }
                }
            }
            .padding(12)
//            .padding(.top, 4)
            .frame(minWidth: 420, minHeight: 520)
        }
    }
    
}

#Preview {
    ContentView()
}
