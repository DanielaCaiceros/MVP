import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = true
    
    var body: some View {
        Group {
            NavigationStack {
                DashboardView(modelContext: modelContext)
            }
        }
    }
}
