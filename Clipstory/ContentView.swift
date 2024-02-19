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
                Text("Select an item from the list.")
            }
        }
    }
}

struct DetailView: View {
    var selectedItem: ClipboardItem
    
    var body: some View {
        VStack {
            Text("\(selectedItem.content) Details")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
            
            Text("Detail 2")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ClipboardHistoryViewModel())
    }
}
