//
//  SystemInfo.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//
import Foundation

class SystemInfo: ObservableObject {
    @Published var macOSVersion: String = ""
    @Published var modelIdentifier: String = ""
    @Published var cpuName: String = ""
    @Published var totalCpuCount: String = ""
    @Published var availableCpuCount: String = ""
    @Published var totalRAM: String = ""
    @Published var uptime: String = ""
    
    init() {
        macOSVersion = ProcessInfo.processInfo.operatingSystemVersionString
        modelIdentifier = getSysctlString(for: "hw.model")
        cpuName = getSysctlString(for: "machdep.cpu.brand_string")
        totalCpuCount = ProcessInfo.processInfo.processorCount.description
        availableCpuCount = ProcessInfo.processInfo.activeProcessorCount.description
        totalRAM = formatBytes(ProcessInfo.processInfo.physicalMemory)
        uptime = formatUptime(TimeInterval(ProcessInfo.processInfo.systemUptime))
    }
    
    private func getSysctlString(for key: String) -> String {
        var size = 0
        sysctlbyname(key, nil, &size, nil, 0)
        var buffer = [CChar](repeating: 0, count: size)
        sysctlbyname(key, &buffer, &size, nil, 0)
        return String(cString: buffer)
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let gb = Double(bytes) / (1024 * 1024 * 1024)
        return String(format: "%.1f GB", gb)
    }
    
    private func formatUptime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
