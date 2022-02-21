import SwiftUI




//final class ObjectLibraryLoader {
//    func fetchObjects() async -> [LocalLibraryObject] {
//
//    }
//}


final class LocalLibraryListViewModel: ObservableObject {
    
    
    
    lazy var localLibraryObjectViewModels: [LocalLibraryObjectViewModel] = [
        .init(
            name: "Black wooden Chair",
            imageName: "",
            onSelect: { [weak self] objectName in self?.onSelectItem(name: objectName) },
            onRemove: { [weak self] objectName in self?.onRemoveItem(name: objectName) },
            onFavorite: { [weak self] objectName in self?.onFavoriteItem(name: objectName) }
        ),
        .init(
            name: "Stool",
            imageName: "",
            onSelect: { [weak self] objectName in self?.onSelectItem(name: objectName) },
            onRemove: { [weak self] objectName in self?.onRemoveItem(name: objectName) },
            onFavorite: { [weak self] objectName in self?.onFavoriteItem(name: objectName) }
        )
    ]
    
    
    private func onSelectItem(name: String) {
        print("Item selected with name: \(name)")
    }
    
    private func onRemoveItem(name: String) {
        print("Item removed with name: \(name)")
    }
    
    private func onFavoriteItem(name: String) {
        print("Item favorited with name: \(name)")
    }
}






struct LocalLibraryObjectView: View {
    @ObservedObject var viewModel: LocalLibraryObjectViewModel
    
    var body: some View {
        HStack {
            Image("Image_Not_Available")
                .resizable()
                //.aspectRatio(0.8, contentMode: .fit)
                .scaledToFit()
                .frame(width: 160, height: 175, alignment: .leading)
            Spacer()
            VStack {
                Text(viewModel.name)
                    .foregroundColor(.white)
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
struct LocalLibraryListView: View {
    
    @StateObject var viewModel = LocalLibraryListViewModel()
    //
    //let items: [String] = [
    //    "Black wooden Chair",
    //    "Stool",
    //    "Slate",
    //    "Black wooden Chaird",
    //    "Stoolf",
    //    "Slate",
    //    "Black wooden Chairg",
    //    "Stoolh",
    //    "Slatea"
    //]
    
    init() {
        //UITableView.appearance().contentInset.top = -45
        
        UINavigationBar.appearance().tintColor = .white
    }
    
    // image height = 100
    // => image width = 80
    var body: some View {
        
        List {
            
            ForEach(viewModel.localLibraryObjectViewModels, id: \.name) { localLibraryObjectViewModel in
                LocalLibraryObjectView(viewModel: localLibraryObjectViewModel)
            }
            
            
            .listRowSeparator(.visible)
            .listRowSeparatorTint(.white)
            .listRowBackground(Color.black)
            //.listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
        }
        .listStyle(PlainListStyle())
        //.padding(.leading, -50)
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



