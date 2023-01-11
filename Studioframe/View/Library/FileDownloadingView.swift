import Foundation
import SwiftUI

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
