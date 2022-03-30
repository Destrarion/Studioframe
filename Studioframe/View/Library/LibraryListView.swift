import SwiftUI

struct LibraryListView: View {
    @StateObject var viewModel = LibraryViewModel()
    init() {
        UINavigationBar.appearance().tintColor = UIColor(named: "ListRowColor")
    }

    var body: some View {
        List {
            ForEach(viewModel.localLibraryObjectViewModels, id: \.name) { localLibraryObjectViewModel in
                LibraryObjectView(viewModel: localLibraryObjectViewModel)
            }
            .listRowSeparator(.visible)
            .listRowSeparatorTint(Color("ListRowColor"))
            .listRowBackground(Color.clear)
        }
        .task {
            viewModel.fetchObjects()
        }
        .listStyle(PlainListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Local Library")
        
    }
}


