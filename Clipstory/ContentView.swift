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
            // Top Content
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
            .frame(maxHeight: .infinity) // Allows the scroll view to expand

            Divider()

            // Bottom Content
            Text("Detail 2")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .frame(maxHeight: .infinity) // Allows this text to expand
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ClipboardHistoryViewModel())
    }
}
