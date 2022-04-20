import SwiftUI

struct LibraryObjectView: View {
    @ObservedObject var viewModel: LibraryObjectViewModel
    
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
    }
}


struct FileDownloadingView: View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    
    var body: some View {
        VStack {
            ProgressView(value: Double(viewModel.downloadProgress) / 100.0)
                .progressViewStyle(.linear)
            Button("Stop") {
                viewModel.didTapStopDownload()
            }
        }
    }
}
