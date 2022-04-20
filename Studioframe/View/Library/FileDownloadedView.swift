import SwiftUI



struct FileDownloadedView: View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.didTapSelect()
            } label: {
                Text("Select")
                    .lineLimit(1)
            }
            
            Spacer()
            Button {
                viewModel.didTapRemove()
            } label: {
                Text("Remove")
                    .lineLimit(1)
            }
            Spacer()
            Button {
                viewModel.didTapFavorite()
            } label: {
                Text("Favorite")
                    .lineLimit(1)
            }

        }
        .buttonStyle(PlainButtonStyle())
    }
}
