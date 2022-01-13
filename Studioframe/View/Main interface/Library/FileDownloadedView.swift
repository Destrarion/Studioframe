import SwiftUI



struct FileDownloadedView: View {
    
    var body: some View {
        HStack {
            Button {
                print("selected")
            } label: {
                Text("Select")
                    .foregroundColor(.white)
            }
            Button {
                print("removed")
            } label: {
                Text("Remove")
                    .foregroundColor(.white)
            }
            Button {
                print("favorited")
            } label: {
                Text("Favorite")
                    .foregroundColor(.white)
            }

        }
    }
}
