//
//  ClipstoryApp.swift
//  Clipstory
//
//  Created by Alan Chang on 2/18/24.
//

import SwiftUI

@main
struct ClipstoryApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView() // Your main SwiftUI view
        }
    }
}
