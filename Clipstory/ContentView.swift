import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ClipboardHistoryViewModel()
    @State private var selectedItemId: UUID?
    @State private var searchText: String = ""  // Initialize the searchText variable

    var body: some View {
        NavigationSplitView {
            // Primary column (List of items)
                List(filteredItems, selection: $selectedItemId) { item in
                    Text(item.content)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cornerRadius(5)
                }
                .listStyle(.sidebar)
                .searchable(text: $searchText) // Add searchable modifier
                .navigationDestination(for: ClipboardItem.self) { item in
                    DetailView(selectedItem: item)
            }
        } detail: {
            // Detail column
            if let selectedItemId = selectedItemId, let selectedItem = filteredItems.first(where: { $0.id == selectedItemId }) {
                DetailView(selectedItem: selectedItem)
            } else {
                Text("Select an item.")
            }
        }
    }
    
    // Computed property to filter items based on search text
    var filteredItems: [ClipboardItem] {
        guard !searchText.isEmpty else {
            return viewModel.clipboardItems
        }
        return viewModel.clipboardItems.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
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
