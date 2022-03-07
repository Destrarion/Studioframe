import SwiftUI




//final class ObjectLibraryLoader {
//    func fetchObjects() async -> [LocalLibraryObject] {
//
//    }
//}




struct UsdzObject: Decodable {
    let title: String
    let objectUrlString: String
}


@MainActor
final class LocalLibraryListViewModel: ObservableObject {
    
    
    
    private let networkManager = NetworkManager.shared
    
    func fetchObjects() {
        Task {
            let url = URL(string: "http://127.0.0.1:8080/usdz-objects")!
            let urlRequest = URLRequest(url: url)
            
            let usdzObjects: [UsdzObject] = try await networkManager.fetch(urlRequest: urlRequest)
            
            self.localLibraryObjectViewModels = usdzObjects.map {
                LocalLibraryObjectViewModel(
                    usdzObject: $0,
                    onSelect: { [weak self] usdzObject in self?.onSelectItem(usdzObject: usdzObject) },
                    onRemove: { [weak self] usdzObject in self?.onRemoveItem(usdzObject: usdzObject) },
                    onFavorite: { [weak self] usdzObject in self?.onFavoriteItem(usdzObject: usdzObject) }
                )
            }
        }
    }
    
    
    
    @Published var localLibraryObjectViewModels: [LocalLibraryObjectViewModel] = []
    
    
    private func onSelectItem(usdzObject: UsdzObject) {
        Task {
            print("Item selected with name: \(usdzObject.title)")
            
            let url = URL(string: "http://127.0.0.1:8080/" + usdzObject.objectUrlString)!
            let urlRequest = URLRequest(url: url)
            
            let usdzObjectLocalFileUrl: URL = try await networkManager.fetchFile(urlRequest: urlRequest)
//            let usdzObjecctData: Data = try await networkManager.fetchData(urlRequest: urlRequest)
            
            print(usdzObjectLocalFileUrl.absoluteString)
            
            let newLocationUrl = getDocumentsDirectory().appendingPathComponent(usdzObject.objectUrlString)
            
            print(newLocationUrl.absoluteString)
            
//            do {
//                try usdzObjecctData.write(to: newLocationUrl)
//            } catch {
//                print("FAILED TO WRAITE")
//                print(error)
//                return
//            }
            
//
            do {
                try FileManager.default.copyItem(at: usdzObjectLocalFileUrl, to: newLocationUrl)
                //try FileManager.default.copyItem(atPath: usdzObjectLocalFileUrl.absoluteString, toPath: newLocationUrl.absoluteString)

            } catch {
                print("FAILED TO COPY USDZ FILE")
                print(error)
                return
            }
//
            
            NotificationCenter.default.post(name: .shouldAddUsdzObject, object: newLocationUrl)
            
        }
        
        
        
        
        //networkManager.fetchData(urlRequest: )
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    private func onRemoveItem(usdzObject: UsdzObject) {
        print("Item removed with name: \(usdzObject.title)")
    }
    
    private func onFavoriteItem(usdzObject: UsdzObject) {
        print("Item favorited with name: \(usdzObject.title)")
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
    
    init() {
        
        UINavigationBar.appearance().tintColor = .white
    }

    var body: some View {
        
        List {
            
            ForEach(viewModel.localLibraryObjectViewModels, id: \.name) { localLibraryObjectViewModel in
                LocalLibraryObjectView(viewModel: localLibraryObjectViewModel)
            }
            
            
            .listRowSeparator(.visible)
            .listRowSeparatorTint(Color("ListRowColor"))
            .listRowBackground(Color.clear)
            //.listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
        }
        .task {
            viewModel.fetchObjects()
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



