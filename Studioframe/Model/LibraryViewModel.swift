//
//  Main.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import Foundation
import SwiftUI






@MainActor
final class LibraryViewModel: ObservableObject {
    
    
    // MARK: - INTERNAL
    
    // MARK: Internal - Properties
    
    @Published var isAlertPresented = false
    @Published var localLibraryObjectViewModels: [LibraryObjectViewModel] = []
    @Published var isLoadingList: Bool = true
    // MARK: Internal - Methods
    
    func fetchObjects() {
        Task {
            let usdzObjects = try await usdzLibraryService.fetchUsdzObjects()
            
            
            let localLibraryObjectViewModels = usdzObjects.map {
                LibraryObjectViewModel(
                    usdzObject: $0,
                    onSelect: { [weak self] usdzObject in self?.onSelectItem(usdzObject: usdzObject)},
                    onRemove: { [weak self] usdzObject in self?.onRemoveItem(usdzObject: usdzObject) },
                    onFavorite: { [weak self] usdzObject in self?.onFavoriteItem(usdzObject: usdzObject) },
                    didProduceError: { [weak self] error in
                        self?.isAlertPresented = true
                        
                    }
                )
            }
            isLoadingList.toggle()
            self.localLibraryObjectViewModels = localLibraryObjectViewModels
            
        }
    }

    

    
    func onRemoveItem(usdzObject: UsdzObject) {
        guard let url = usdzLibraryService.urlPathUsdzObjects[usdzObject.title] else { return print("Error finding url for removing")}
        usdzLibraryService.removeUsdzObject(locationUrl: url)
        usdzLibraryService.downloadedUsdzObjects[usdzObject.title]?.toggle()
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
        
    }
    

}




