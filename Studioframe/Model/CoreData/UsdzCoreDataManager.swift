import Foundation
import CoreData


protocol UsdzCoreDataManagerProtocol {
    func addItem(usdz: UsdzObject)
    func getItems() -> [UsdzObject]
    func deleteItem(with usdz: UsdzObject)
}

class UsdzCoreDataManager: UsdzCoreDataManagerProtocol {
    
    init(coreDataContextProvider: CoreDataContextProviderProtocol =  CoreDataContextProvider.shared) {
        self.coreDataContextProvider = coreDataContextProvider
    }
    
    //MARK: - Internal - static let
    static let shared = UsdzCoreDataManager()
    
    /// Add the item into CoreData
    ///
    /// This function will add the title, image, total time , ingredients and the url  into CoreData to become a Favorite Item.
    /// - Parameter item: Item to add in favorite
    func addItem(usdz: UsdzObject) {
        let itemEntity = ItemEntity(context: coreDataContextProvider.viewContext)
        itemEntity.title = usdz.title
        itemEntity.url = usdz.objectUrlString
        itemEntity.imageURL = usdz.thumbnailImageUrlString
        try? coreDataContextProvider.save()
    }
    
    /// Function called to get all the favorite item.
    ///
    /// Get all the favorite item with their titles, images, total time , ingredients and the URL.
    /// - Returns: Return Item, to fit in the tableview of ItemListController
    func getItems() -> [UsdzObject] {
        
        let itemEntities = getItemEntities()
        
        let items = itemEntities.map { itemEntity in
            UsdzObject(
                title: itemEntity.title,
                objectUrlString: itemEntity.url,
                thumbnailImageUrlString: itemEntity.imageURL
            )
        }
        
        return items
        
    }
    
    /// Function to delete favorite item in Core Data.
    /// - Parameter title: Title of the item to delete
    func deleteItem(with usdz: UsdzObject) {
        let itemEntities = getItemEntities()
        for itemEntity in itemEntities where itemEntity.title == usdz.title {
            coreDataContextProvider.delete(itemEntity)
            
        }
        
        try? coreDataContextProvider.save()
        
    }
    
    /// Delete all the favorite item in CoreData.
    /// Called for test for CoreData
    func deleteAllItems() throws {
        let itemEntities = getItemEntities()
        
        for itemEntity in itemEntities {
            coreDataContextProvider.delete(itemEntity)
        }
        
        try coreDataContextProvider.save()
    }
    
    //MARK: Private
    //MARK: Private - Function
    /// Function to get a specific entity in CoreData, Return ItemEntity to get access to the favorite Item in CoreData
    /// - Returns: ItemEntity, contains the information for the title, image, total time , ingredients and the url.
    private func getItemEntities() -> [ItemEntity] {
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        
        guard let itemEntities = try? coreDataContextProvider.fetch(request) else { return [] }
        
        return itemEntities
    }
    
    //MARK: Private - Let
    private let coreDataContextProvider: CoreDataContextProviderProtocol
}

