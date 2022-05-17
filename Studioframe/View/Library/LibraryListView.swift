import SwiftUI

struct LibraryListView: View{
    
    @StateObject var viewModel: LibraryViewModel
    
    init() {
        UINavigationBar.appearance().tintColor = UIColor(named: "ListRowColor")
        self._viewModel = StateObject(wrappedValue: LibraryViewModel())
    }
    
    
    var body: some View {
        Group {
            if viewModel.isLoadingList {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                List {
                    
                    ForEach(viewModel.localLibraryObjectViewModels, id: \.name) { viewModel in
                        LibraryObjectView(viewModel: viewModel)
                    }
                    .listRowSeparator(.visible)
                    .listRowSeparatorTint(Color("ListRowColor"))
                    .listRowBackground(Color.clear)
                }
                .alert("Error", isPresented: $viewModel.isAlertPresented, actions: {})
                .listStyle(PlainListStyle())
            }
        }
        .task {
            viewModel.fetchObjects()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Local Library")
        
    }
}


