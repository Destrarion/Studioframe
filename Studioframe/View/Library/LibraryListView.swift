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
                List {
                    
                    VStack {          
                        Button("Test Dismiss Presentation Mode") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                    
                    
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


