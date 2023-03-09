import Foundation

@MainActor
final class USDZScrollingMenuViewModel: ObservableObject {
    
    @Published var usdzObjectContainers: [UsdzObjectContainer] = []
    
    private let usdzLibraryService = UsdzLibraryService.shared
    
    init() {
        let favoritedObjects = usdzLibraryService.getFavoriteObjects()
        
        usdzObjectContainers = favoritedObjects.map {
            return UsdzObjectContainer(fileName: $0.title, fileUrl: $0.objectUrlString)
        }
    }
}
