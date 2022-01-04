import SwiftUI

struct LocalLibraryListView: View {
    
    let items: [String] = [
        "Black wooden Chair",
        "Stool",
        "Slate",
        "Black wooden Chaird",
        "Stoolf",
        "Slate",
        "Black wooden Chairg",
        "Stoolh",
        "Slatea"
    ]
    
    init() {
        UITableView.appearance().backgroundColor = .black
        UITableView.appearance().contentInset.top = -45
        
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        
        List {
            
            ForEach(items, id: \.self) { item in
                HStack{
                    Image("Image_Not_Available")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    VStack {
                        Text(item)
                            .foregroundColor(.white)
                            .frame(width: 175, alignment: .topLeading)
                            .font(.body.bold())
                        
                        Spacer()
                        FileDownloadedView()
                    }
                    
                }
                .padding(.top, 10)
            }
            
            
            .listRowSeparator(.visible)
            .listRowSeparatorTint(.white)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
        }
        .padding(.leading, -50)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Local Library")
        
    }
}





#if DEBUG
struct LibraryListView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                LocalLibraryListView()
                    .previewInterfaceOrientation(.portrait)
            }
        }
    }
}
#endif



