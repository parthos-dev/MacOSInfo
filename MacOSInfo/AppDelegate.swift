//
//  AppDelegate.swift
//  MacOSInfo
//
//  Created by Parth Sutaria on 6/24/25.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.delegate = self
            window.title = "MacOS Status"
            window.setContentSize(NSSize(width: 470, height: 680)) // Set starting size
            window.minSize = NSSize(width: 470, height: 680)       // Allow resizing below
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(nil)
    }
}
