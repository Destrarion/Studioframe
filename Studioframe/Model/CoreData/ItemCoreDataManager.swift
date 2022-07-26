import Foundation
import CoreData


protocol ItemCoreDataManagerProtocol {
    func addItem(item: Item)
    func getItems() -> [Item]
    func deleteItem(with title: String)
}

class ItemCoreDataManager: ItemCoreDataManagerProtocol {
    
    static let shared = ItemCoreDataManager()
    
    init(coreDataContextProvider: CoreDataContextProviderProtocol =  CoreDataContextProvider.shared) {
        self.coreDataContextProvider = coreDataContextProvider
    }
    
    private let coreDataContextProvider: CoreDataContextProviderProtocol
    
    
    /// Add the item into CoreData
    ///
    /// This function will add the title, image, total time , ingredients and the url  into CoreData to become a Favorite Item.
    /// - Parameter item: Item to add in favorite
    func addItem(item: Item) {
        let itemEntity = ItemEntity(context: coreDataContextProvider.viewContext)
        itemEntity.title = item.title
        try? coreDataContextProvider.save()
    }
    
    /// Function called to get all the favorite item.
    ///
    /// Get all the favorite item with their titles, images, total time , ingredients and the URL.
    /// - Returns: Return Item, to fit in the tableview of ItemListController
    func getItems() -> [Item] {
        
        let itemEntities = getItemEntities()
        
        let items = itemEntities.map { itemEntity in
            Item(title: itemEntity.title)
        }
        
        return items
        
    }
    
    /// Function to delete favorite item in Core Data.
    /// - Parameter title: Title of the item to delete
    func deleteItem(with title: String) {
        let itemEntities = getItemEntities()
        for itemEntity in itemEntities where itemEntity.title == title {
            coreDataContextProvider.delete(itemEntity)
            
        }
        
        try? coreDataContextProvider.save()
        
    }
    
    /// Delete all the favorite item in CoreData.
    /// Called for test for CoreData
    func deleteAllItems() {
        let itemEntities = getItemEntities()
        
        for itemEntity in itemEntities {
            coreDataContextProvider.delete(itemEntity)
        }
        
        try? coreDataContextProvider.save()
    }
    
    

    
    
    /// Function to get a specific entity in CoreData, Return ItemEntity to get access to the favorite Item in CoreData
    /// - Returns: ItemEntity, contains the information for the title, image, total time , ingredients and the url.
    private func getItemEntities() -> [ItemEntity] {
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        
        guard let itemEntities = try? coreDataContextProvider.fetch(request) else { return [] }
        
        return itemEntities
    }
    
    
    
}



class Item {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}
