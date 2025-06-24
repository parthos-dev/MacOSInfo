//
//  CoreMonitor.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import Foundation
import Darwin.Mach

private struct CPUTicks {
    let user: Double
    let system: Double
    let idle: Double
    let nice: Double
    
    var total: Double { user + system + idle + nice }
    var active: Double { user + system + nice }
}

class MultiCoreMonitor: ObservableObject {
    @Published var coreHistories: [UsageHistory] = []
    private var previousTicks: [CPUTicks] = []
    
    private var prevCpuInfo: processor_info_array_t?
    private var prevCpuCount: mach_msg_type_number_t = 0
    private var timer: Timer?
    
    init() {
        setupCores()
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func setupCores() {
        let coreCount = ProcessInfo.processInfo.processorCount
        coreHistories = (0..<coreCount).map { _ in UsageHistory()}
        previousTicks = Array(repeating: CPUTicks(user: 0, system: 0, idle: 0, nice: 0), count: coreCount)
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.updateUsage()
        }
    }
    
    private func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateUsage() {
        var cpuCount: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var infoCount: mach_msg_type_number_t = 0
        
        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &cpuCount,
            &cpuInfo,
            &infoCount
        )
        
        guard result == KERN_SUCCESS, let newCpuInfo = cpuInfo else {
            return
        }
        
        for i in 0..<Int(cpuCount) {
            let base = i * Int(CPU_STATE_MAX)
            
            let user = Double(newCpuInfo[base + Int(CPU_STATE_USER)])
            let sys = Double(newCpuInfo[base + Int(CPU_STATE_SYSTEM)])
            let idle = Double(newCpuInfo[base + Int(CPU_STATE_IDLE)])
            let nice = Double(newCpuInfo[base + Int(CPU_STATE_NICE)])
            
            let total = user + sys + idle + nice
            let active = user + sys + nice
            
            let curr = CPUTicks(user: user, system: sys, idle: idle, nice: nice)
            let prev = previousTicks[i]
            
            let deltaTotal = total - prev.total
            let deltaActive = active - prev.active
            let usage = deltaTotal > 0 ? deltaActive / deltaTotal : 0
            previousTicks[i] = curr
            
            DispatchQueue.main.async {
                if i < self.coreHistories.count {
                    self.coreHistories[i].add(usage: usage)
                }
            }
        }
        
        if let prev = prevCpuInfo {
            let size = Int(prevCpuCount) * MemoryLayout<integer_t>.stride
            vm_deallocate(
                mach_task_self_,
                vm_address_t(bitPattern: prev),
                vm_size_t(size)
            )
        }
        
        prevCpuInfo = newCpuInfo
        prevCpuCount = infoCount
        
    }
}
