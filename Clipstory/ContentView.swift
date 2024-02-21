import SwiftUI



struct ContentView: View {
    @StateObject var viewModel = ClipboardHistoryViewModel()
    @State private var selectedItemId: UUID?
    
    var body: some View {
        NavigationSplitView {
            // Primary column (List of items)
            List(viewModel.clipboardItems, selection: $selectedItemId) { item in
                Text(item.content)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cornerRadius(5)
                // No onTapGesture needed; selection is handled by List
            }
            .listStyle(.sidebar)
            
            // Correct placement of navigationDestination
            .navigationDestination(for: ClipboardItem.self) { item in
                // Destination view for the selected item
                DetailView(selectedItem: item)
            }
        } detail: {
            // Detail column
            if let selectedItemId = selectedItemId, let selectedItem = viewModel.clipboardItems.first(where: { $0.id == selectedItemId }) {
                DetailView(selectedItem: selectedItem)
            } else {
                Text("Select an item.")
            }
        }
    }
}

struct DetailView: View {
    var selectedItem: ClipboardItem
    
    var body: some View {
        VStack {
            // Container for the top content
            VStack(alignment: .leading) {
                Text("\(selectedItem.content) Details")
                    .font(.custom("Monaco", size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    .padding() // Add padding for better appearance
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
