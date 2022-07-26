import SwiftUI




struct LibraryObjectView: View {
    @ObservedObject var viewModel: LibraryObjectViewModel

    
    var body: some View {
        HStack {
            Button {
                if viewModel.donwloadedUsdzObjectUrl != nil {
                    viewModel.isQuickLookPresented = true
                }
            } label: {
                AsyncImage(
                    url: viewModel.thumbnailImageUrl,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 175, alignment: .leading)
                        
                    },
                    placeholder: {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                
                            .frame(width: 160, height: 175, alignment: .leading)
                    }
                )
            }


                
            Spacer()
            VStack {
                Text(viewModel.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body.bold())
                
                Spacer()
                
                switch viewModel.downloadState {
                case .notDownloaded:
                    FileNotDowloadedView(viewModel: viewModel)
                case .downloading:
                    FileDownloadingView(viewModel: viewModel)
                case .downloaded:
                    FileDownloadedView(viewModel: viewModel)
                }
            }
            
        }
        .padding(.vertical, 10)
        .frame(height: 200)
        .sheet(isPresented: $viewModel.isQuickLookPresented) {
            NavigationView {
                QuickLookView(objectUrl: viewModel.donwloadedUsdzObjectUrl!)
                    .toolbar {
                        Button("Close") {
                            print("Should close")
                            viewModel.isQuickLookPresented = false
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}


