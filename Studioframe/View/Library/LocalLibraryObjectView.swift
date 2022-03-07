import SwiftUI

struct LocalLibraryObjectView: View {
    @ObservedObject var viewModel: LocalLibraryObjectViewModel
    
    var body: some View {
        HStack {
            Image("Image_Not_Available")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 175, alignment: .leading)
            Spacer()
            VStack {
                Text(viewModel.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body.bold())
                
                Spacer()
                FileDownloadedView(viewModel: viewModel)
            }
            
        }
        .padding(.vertical, 10)
        .frame(height: 200)
    }
}
