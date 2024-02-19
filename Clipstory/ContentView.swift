import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ClipboardHistoryViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.clipboardItems) { item in
                NavigationLink(destination: Text("\(item.content) Details")) {
                    Text(item.content)
                }
                .padding(.vertical, 8)
            }
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 400)
            .listStyle(SidebarListStyle())
            
            Text("Select an item")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 700, idealWidth: 1000, maxWidth: .infinity, minHeight: 400, idealHeight: 600, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

