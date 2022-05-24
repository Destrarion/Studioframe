import SwiftUI


struct FileNotDowloadedView : View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                viewModel.didTapDownload()
                print("Downloading")
            } label: {
                Text("Download")
                    .frame( maxWidth: 600, maxHeight: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.gray,lineWidth: 5.0)
                    )
            }
        }
    }
    
}
