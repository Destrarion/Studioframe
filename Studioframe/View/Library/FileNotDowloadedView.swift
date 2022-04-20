import SwiftUI


struct FileNotDowloadedView : View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.didTapDownload()
                print("Downloading")
            } label: {
                Text("Download")
            }
        }
    }
    
}
