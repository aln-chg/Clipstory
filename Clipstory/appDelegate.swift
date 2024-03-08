import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var viewModel = ClipboardHistoryViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the popover content with padding and the copy functionality
        let menuBarListView = MenuBarListView(viewModel: viewModel, copyTextToClipboard: { text in
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(text, forType: .string)
        })
        .padding()  // Add padding around the MenuBarListView

        // Initialize the popover with the content
        popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 360)  // Adjust this size if needed to accommodate padding
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
