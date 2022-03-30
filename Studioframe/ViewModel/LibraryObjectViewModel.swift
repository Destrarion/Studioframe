import Foundation

final class LibraryObjectViewModel: ObservableObject {
    init(
        usdzObject: UsdzObject,
        onSelect: @escaping (UsdzObject) -> Void,
        onRemove: @escaping (UsdzObject) -> Void,
        onFavorite: @escaping (UsdzObject) -> Void
    ) {
        self.usdzObject = usdzObject
        self.onSelect = onSelect
        self.onRemove = onRemove
        self.onFavorite = onFavorite
    }
    
    var name: String {
        usdzObject.title
    }
    
    @Published var imageName: String = ""
    let usdzObject: UsdzObject
    
    private let onSelect: (UsdzObject) -> Void
    private let onRemove: (UsdzObject) -> Void
    private let onFavorite: (UsdzObject) -> Void
    
    func didSelect() {
        onSelect(usdzObject)
    }
    
    func didRemove() {
        onRemove(usdzObject)
    }
    
    func didFavorite() {
        onFavorite(usdzObject)
    }
}
