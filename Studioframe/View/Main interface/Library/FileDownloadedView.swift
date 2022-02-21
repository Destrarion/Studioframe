import SwiftUI



struct FileDownloadedView: View {
    
    @ObservedObject var viewModel: LocalLibraryObjectViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.didSelect()
            } label: {
                Text("Select")
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            Button {
                viewModel.didRemove()
            } label: {
                Text("Remove")
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            Spacer()
            Button {
                viewModel.didFavorite()
            } label: {
                Text("Favorite")
                    .foregroundColor(.white)
                    .lineLimit(1)
            }

        }
        .buttonStyle(PlainButtonStyle())
    }
}
