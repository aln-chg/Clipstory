import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ClipboardHistoryViewModel()
    @State private var selectedItemId: UUID?
    @State private var searchText: String = ""

    var body: some View {
        NavigationSplitView {
                    List(filteredItems, selection: $selectedItemId) { item in
                        HStack {
                            Text(item.content)
                                .lineLimit(1) // Ensures the text does not wrap
                                .truncationMode(.tail) // Adds "..." at the end if the text is too long
                                .padding(8)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                            Button(action: {
                                // Copy the item content to the clipboard
                                copyTextToClipboard(text: item.content)
                            }) {
                                Image(systemName: "doc.on.clipboard") // The copy icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20) // Adjust the size as needed
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.trailing, 8) // Padding to keep the button visible
                        }
                    }
                    .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity) // Set your desired width here
                    .searchable(text: $searchText) // Add searchable modifier
                } detail: {
            if let selectedItemId = selectedItemId, let selectedItem = filteredItems.first(where: { $0.id == selectedItemId }) {
                DetailView(selectedItem: selectedItem)
            } else {
                Text("Select an item.")
            }
        }
    }

    var filteredItems: [ClipboardItem] {
        guard !searchText.isEmpty else {
            return viewModel.clipboardItems
        }
        return viewModel.clipboardItems.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
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
        VStack {
            // Container for the top content
            VStack(alignment: .leading) {
                ScrollView{
                    Text("\(selectedItem.content)")
                }
                    .font(.custom("Monaco", size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    .padding(5) // Add padding for better appearance
                
            }
            .frame(maxHeight: .infinity, alignment: .topLeading) // Align this VStack to the top

            Divider()

            // Container for the bottom content
            VStack {
                Text("Detail 2")
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    .padding() // Add padding for better appearance
            }
            .frame(maxHeight: .infinity, alignment: .topLeading) // Keep this content at the top of its container
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ClipboardHistoryViewModel())
    }
}
