import SwiftUI

struct LibraryListView: View{
    
    @StateObject var viewModel: LibraryViewModel
    
    init() {
        UINavigationBar.appearance().tintColor = UIColor(named: "ListRowColor")
        self._viewModel = StateObject(wrappedValue: LibraryViewModel())
    }
    
    
    var body: some View {
        List {
//            if viewModel.isLoadingList {
//                ProgressView()
//                    .progressViewStyle(.linear)
//            }
            ForEach(viewModel.localLibraryObjectViewModels, id: \.name) { localLibraryObjectViewModel in
                LibraryObjectView(viewModel: localLibraryObjectViewModel)
            }
            .listRowSeparator(.visible)
            .listRowSeparatorTint(Color("ListRowColor"))
            .listRowBackground(Color.clear)
        }
        .alert("Error", isPresented: $viewModel.isAlertPresented, actions: {})
        .task {
            viewModel.fetchObjects()
            
        }
        .listStyle(PlainListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Local Library")
        
    }
}


