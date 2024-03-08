import SwiftUI
import AppKit


struct ContentView: View {
    @StateObject var viewModel = ClipboardHistoryViewModel()
    @State private var selectedItemId: UUID?
    @State private var searchText: String = ""

    var body: some View {
        NavigationSplitView {
            List(viewModel.clipboardItems, selection: $selectedItemId) { item in
                HStack {
                    itemContentView(item)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        if case .text(let text) = item.content {
                            copyTextToClipboard(text: text)
                        }
                    }) {
                        Image(systemName: "doc.on.clipboard")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity)
            .searchable(text: $searchText)
        } detail: {
            if let itemId = selectedItemId, let selectedItem = viewModel.clipboardItems.first(where: { $0.id == itemId }) {
                DetailView(selectedItem: selectedItem)
            } else {
                Text("Select an item or copy content.")
            }
        }
    }

    private func itemContentView(_ item: ClipboardItem) -> some View {
        Group {
            switch item.content {
            case .text(let text):
                Text(text)
            case .image(_):
                HStack {
                    Text("Image")
                    Image(systemName: "photo").resizable().frame(width: 10, height: 10)
                }
            }
        }
    }

    func copyTextToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

struct DetailView: View {
    var selectedItem: ClipboardItem

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    switch selectedItem.content {
                    case .text(let text):
                        Text(text)
                            .font(.custom("Monaco", size: 12))
                            .padding()
                    case .image(let image):
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            // Control the expansion to split space evenly
            .frame(maxHeight: .infinity)

            Divider()

            // Use a GroupBox for better visual separation and padding control
                VStack(alignment: .leading, spacing: 8) { // Add spacing between texts
                    Text("Data Type: \(dataType(for: selectedItem.content))")
                    Text("Time of Copy: \(formattedTime(of: selectedItem.timeOfCopy))")
                    if case .text(let text) = selectedItem.content {
                        Text("Character Count: \(text.count)")
                        Text("Word Count: \(wordCount(of: text))")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .topLeading) // Aligns the content to the left
                .padding()
        }
    }

    private func dataType(for content: ClipboardContent) -> String {
        switch content {
        case .text: return "Text"
        case .image: return "Image"
        }
    }

    private func formattedTime(of date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func wordCount(of text: String) -> Int {
        let words = text.split { !$0.isLetter }
        return words.count
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ClipboardHistoryViewModel())
    }
}
