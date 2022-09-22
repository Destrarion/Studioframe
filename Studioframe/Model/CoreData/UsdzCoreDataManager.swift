import Foundation
import CoreData
import SwiftUI


protocol UsdzCoreDataManagerProtocol {
    func addItem(usdz: UsdzObject)
    func getItems() -> [UsdzObject]
    func deleteItem(with usdz: UsdzObject)
}

class UsdzCoreDataManager: UsdzCoreDataManagerProtocol {
    
    static let shared = UsdzCoreDataManager()
    
    init(coreDataContextProvider: CoreDataContextProviderProtocol =  CoreDataContextProvider.shared) {
        self.coreDataContextProvider = coreDataContextProvider
    }
    
    private let coreDataContextProvider: CoreDataContextProviderProtocol
    
    
    /// Add the item into CoreData
    ///
    /// This function will add the title, image, total time , ingredients and the url  into CoreData to become a Favorite Item.
    /// - Parameter item: Item to add in favorite
    func addItem(usdz: UsdzObject) {
        print("💾💾💾💾💾💾💾💾💾")
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



//struct Item {
//    let title: String
//    let url: String
//    let imageURL: String
//
//    init(title: String, url: String, imageURL: String) {
//        self.title = title
//        self.url = url
//        self.imageURL = imageURL
//    }
//}
