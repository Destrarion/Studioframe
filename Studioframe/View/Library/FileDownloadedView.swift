import SwiftUI



struct FileDownloadedView: View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.didSelect()
            } label: {
                Text("Select")
                    .lineLimit(1)
            }
            
            Spacer()
            Button {
                viewModel.didRemove()
            } label: {
                Text("Remove")
                    .lineLimit(1)
            }
            Spacer()
            Button {
                viewModel.didFavorite()
            } label: {
                Text("Favorite")
                    .lineLimit(1)
            }

        }
        .buttonStyle(PlainButtonStyle())
    }
}
