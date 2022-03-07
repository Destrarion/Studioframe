import SwiftUI


struct FileNotDowloadedView : View {
    
    var body: some View {
        HStack {
            Button{
                print("Downloading")
            } label: {
                Text("Download")
            }
        }
    }
    
}
