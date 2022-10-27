import Foundation

@MainActor
final class USDZScrollingMenuViewModel: ObservableObject {
    var usdzLibraryService = UsdzLibraryService.shared
    
    init() {
        
        let favoritedObjects = usdzLibraryService.getFavoriteObjects()
        print("❌❌\(favoritedObjects.count)")
        
        usdzObjectContainers = favoritedObjects.map {
            print($0.title)
            print($0.objectUrlString)
            return UsdzObjectContainer(fileName: $0.title, fileUrl: $0.objectUrlString)
        }
        
        print("❌❌\(usdzObjectContainers.count)")
        print(usdzObjectContainers)
        
    }
    
    @Published var usdzObjectContainers: [UsdzObjectContainer] = []
    
    
    
    // MARK: TEST Seed
    //
    //  func saveDefaultUsdz() {
    //      let url = Bundle.main.url(forResource: "AirForce", withExtension: "usdz")!
    //      fileManager.moveFile(at: url, fileName: "AirForce")
    //  }
    //
    
    //private let fileManager = StudioFrameFileManager.shared
    
    
    
}
