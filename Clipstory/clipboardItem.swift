import SwiftUI
import AppKit

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
            if let copiedString = pasteboard.string(forType: .string) {
                DispatchQueue.main.async { [weak self] in
                    self?.addItem(content: copiedString)
                }
            }
        }
    }
    
    func copyTextToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    func addItem(content: String) {
        let newItem = ClipboardItem(content: content)
        //inserts the new item at the START of the array
        clipboardItems.insert(newItem, at: 0)
        // If there are more than 500 items, remove the oldest
        if clipboardItems.count > 500 {
            clipboardItems.removeLast()
        }
    }
}
