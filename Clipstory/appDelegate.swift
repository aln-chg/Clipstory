//
//  appDelegate.swift
//  Clipstory
//
//  Created by Alan Chang on 3/4/24.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var viewModel = ClipboardHistoryViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up the popover content
        let menuBarListView = MenuBarListView(viewModel: viewModel) { text in
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(text, forType: .string)
        }

        // Initialize the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: menuBarListView)

        // Initialize the status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusBarItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard History")
            button.action = #selector(togglePopover(_:))
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBarItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
