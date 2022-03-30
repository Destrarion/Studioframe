//
//  Main.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import Foundation






@MainActor
final class LibraryViewModel: ObservableObject {
    

    // MARK: - INTERNAL
    
    // MARK: Internal - Properties
    
    @Published var localLibraryObjectViewModels: [LibraryObjectViewModel] = []
   
    // MARK: Internal - Methods
    
    func fetchObjects() {
        Task {
            let usdzObjects = try await usdzLibraryService.fetchUsdzObjects()
            
            let localLibraryObjectViewModels = usdzObjects.map {
                LibraryObjectViewModel(
                    usdzObject: $0,
                    onSelect: { [weak self] usdzObject in self?.onSelectItem(usdzObject: usdzObject)},
                    onRemove: { [weak self] usdzObject in self?.onRemoveItem(usdzObject: usdzObject) },
                    onFavorite: { [weak self] usdzObject in self?.onFavoriteItem(usdzObject: usdzObject) }
                )
            }
            
            self.localLibraryObjectViewModels = localLibraryObjectViewModels
            
        }
    }

    

    
    func onRemoveItem(usdzObject: UsdzObject) {
        print("Item removed with name: \(usdzObject.title)")
    }
    
    func onFavoriteItem(usdzObject: UsdzObject) {
        print("Item favorited with name: \(usdzObject.title)")
    }
    
    
    
    
    
    
    // MARK: - PRIVATE
    
    // MARK: Private - Properties
    
    
    private let usdzLibraryService = UsdzLibraryService.shared
    
    
    // MARK: Private - Methods
    
    private func onSelectItem(usdzObject: UsdzObject) {
        Task {
            print("Item selected with name: \(usdzObject.title)")
            let donwloadedUsdzObjectUrl = try await usdzLibraryService.downloadUsdzObject(usdzObject: usdzObject)
            NotificationCenter.default.post(name: .shouldAddUsdzObject, object: donwloadedUsdzObjectUrl)
            
        }
        
    }
    
}





