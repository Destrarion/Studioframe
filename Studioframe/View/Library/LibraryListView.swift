import SwiftUI

struct LibraryListView: View{
    
    @StateObject var viewModel: LibraryViewModel
    

    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
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
                VStack {
                    Picker("Selected section:", selection: $viewModel.currentLibraryFilterOption) {
                        Group {
                            Text("All")
                                .tag(LibraryFilterOption.all)
                            Text("Favorites")
                                .tag(LibraryFilterOption.favorited)
                            Text("Download")
                                .tag(LibraryFilterOption.downloaded)
                        }
                    }.pickerStyle(.segmented)
                    
                    
                    List {
                        
                        // set selection if downloaded or favorite or not downloaded or all
                        
                        ForEach(viewModel.filteredLocalLibraryObjectViewModels, id: \.name) { viewModel in
                            LibraryObjectView(viewModel: viewModel)
                        }
                        .listRowSeparator(.visible)
                        .listRowSeparatorTint(Color("ListRowColor"))
                        .listRowBackground(Color.clear)
                    }
                    .alert("Error", isPresented: $viewModel.isAlertPresented, actions: {})
                    .listStyle(PlainListStyle())
                }
                .searchable(text: $viewModel.searchText)
            }
            
        }
        .onReceive(viewModel.$shouldDismiss, perform: { shouldDismiss in
            guard shouldDismiss else { return }
            dismiss()
        })
        .task {
            viewModel.fetchObjects()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Local Library")
        
    }
}


