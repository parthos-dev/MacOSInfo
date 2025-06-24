//
//  MacOSInfoApp.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import SwiftUI

@main
struct MacOSInfoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
