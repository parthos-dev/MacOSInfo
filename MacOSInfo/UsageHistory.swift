//
//  UsageHistory.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import Foundation

class UsageHistory: ObservableObject {
    @Published var usageHistory: [Double] = [] {
        didSet {
            usageDidUpdate = Date()
        }
    }
    @Published var usageDidUpdate: Date = Date()
    private let maxPoints: Int = 30
    
    func add(usage: Double) {
        usageHistory.append(usage)
        if usageHistory.count > maxPoints {
            usageHistory.removeFirst()
        }
    }
}
