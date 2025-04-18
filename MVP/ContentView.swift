import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = true
    
    var body: some View {
        BookListView()
            .environmentObject(BookViewModel())
    }
}
