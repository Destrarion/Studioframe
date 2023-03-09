import SwiftUI



struct FileDownloadedView: View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    

    
    var body: some View {
        VStack {
            Spacer()
            Button {
                viewModel.didTapSelect()
            } label: {
                Text("Add to scene")
                    .lineLimit(1)
                    .frame( maxWidth: 600, maxHeight: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.blue,lineWidth: 5.0)
                    )

            }

            
            Spacer()
            Button {
                viewModel.didTapRemove()
            } label: {
                Text("Remove")
                    .lineLimit(1)
                    .frame( maxWidth: 600, maxHeight: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.red,lineWidth: 5.0)
                    )
                    
            }
            Spacer()
            Button {
                viewModel.didTapFavorite()
            } label: {
                if viewModel.isFavorited {
                    Text("Remove Favorite")
                        .lineLimit(1)
                        .frame( maxWidth: 600, maxHeight: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(Color.orange,lineWidth: 5.0)
                        )
                } else {
                Text("Add Favorite")
                    .lineLimit(1)
                    .frame( maxWidth: 600, maxHeight: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.orange,lineWidth: 5.0)
                    )
                }
            }

            Spacer()

        }
        .buttonStyle(PlainButtonStyle())
    }
}
