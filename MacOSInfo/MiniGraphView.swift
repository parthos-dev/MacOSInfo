//
//  CPUMiniGraphView.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import SwiftUI

struct MiniGraphView: View {
    @ObservedObject var history: UsageHistory
    private var label: String = ""
    
    init(label: String, history: UsageHistory) {
        self.label = label
        self.history = history
    }
    
    var body: some View {
        Canvas { context, size in
            guard history.usageHistory.count > 1 else { return }
            
            let path = Path { path in
                let points = history.usageHistory
                let stepX = size.width / CGFloat(points.count - 1)
                
                for (index, usage) in points.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = size.height * (1 - CGFloat(usage))
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            context.stroke(path, with: .color(.green), lineWidth: 1)
        }
        .frame(width: 140, height: 60)
        .background(Color.black.opacity(0.1))
        .cornerRadius(8)
        .overlay(alignment: .topLeading) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(4)
        }
        .overlay(alignment: .bottomTrailing) {
            Text(String(format: "%.1f%%", (history.usageHistory.last ?? 0) * 100))
                .font(.caption2)
                .foregroundColor(.primary)
                .padding(4)
        }
    }
}
