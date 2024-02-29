import SwiftUI
import AppKit


enum ClipboardContent {
    case text(String)
    case image(NSImage)
}

class ClipboardHistoryViewModel: ObservableObject {
    @Published var clipboardItems: [ClipboardItem] = []
    private var changeCount: Int = NSPasteboard.general.changeCount // Tracks clipboard changes
    private var timer: Timer?
    
    init() {
        startMonitoringClipboard()
    }
    
    deinit {
        stopMonitoringClipboard()
    }
    
    func startMonitoringClipboard() {
        // Use a timer to periodically check the clipboard
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    func stopMonitoringClipboard() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        if changeCount != pasteboard.changeCount { // There's new content in the clipboard
            changeCount = pasteboard.changeCount // Update the change count to the current one
            
            var itemToAdd: ClipboardItem?
            
            // Check for images first
            if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
                itemToAdd = ClipboardItem(content: .image(image))
            }
            // Check for strings if no image
            else if let copiedString = pasteboard.string(forType: .string) {
                itemToAdd = ClipboardItem(content: .text(copiedString))
            }
            
            // If we have a new item to add, insert it at the top of the list
            if let newItem = itemToAdd {
                DispatchQueue.main.async { [weak self] in
                    self?.addItem(newItem)
                }
            }
        }
    }
    
    private func addItem(_ newItem: ClipboardItem) {
        clipboardItems.insert(newItem, at: 0) // Inserts the new item at the START of the array
        
        // If there are more than 500 items, remove the oldest
        if clipboardItems.count > 500 {
            clipboardItems.removeLast()
        }
    }
    
    func copyTextToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

// Rest of your SwiftUI views...
