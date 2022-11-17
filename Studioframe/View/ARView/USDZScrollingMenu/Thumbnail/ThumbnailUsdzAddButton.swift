import SwiftUI


struct ThumbnailUsdzAddButton: View {
    
    @ObservedObject var viewModel: UsdzObjectContainer
    
    var body: some View {
        ZStack {
            (viewModel.image ?? Image(systemName: "circle"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .frame(width: 50)
        .cornerRadius(100)
    }
    
}
