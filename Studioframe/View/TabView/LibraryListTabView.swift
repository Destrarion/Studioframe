import SwiftUI

struct LibraryListTabView : View {
 
    @Binding var isScrollingUSDZMenuOpen: Bool
    @Binding var isLibraryPresented: Bool
    
    var body: some View {
        NavigationView() {
            LibraryListView()
        }
        .tabItem {
            Button {
                isScrollingUSDZMenuOpen = false
                isLibraryPresented = true
            } label: {
                Image(systemName: "text.book.closed.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
            }
            Text("Library")
        }
    }
}
