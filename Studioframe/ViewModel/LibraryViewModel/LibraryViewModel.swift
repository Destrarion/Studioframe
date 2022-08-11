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
    @Published var isLoadingList: Bool = false
    @Published var shouldDismiss = false
    
    
    // MARK: Internal - Methods
    
    func fetchObjects() {
        Task {
            isLoadingList = true
            let usdzObjects = try await usdzLibraryService.fetchUsdzObjects()
            print("✈️ LibraryViewModel usdzObjects \(usdzObjects)")
    
            usdzObjects.forEach { usdzobject in
                
               generateLocalLibraryObjectViewModels(usdzObjects: usdzObjects)
            }
            
            isLoadingList = false
            
        }
    }
    

    
    func onFavoriteItem(usdzObject: UsdzObject) {
        print("Item favorited with name: \(usdzObject.title)")
    }
    
    
    
    
    // MARK: - PRIVATE
    
    // MARK: Private - Properties
    
    
    private let usdzLibraryService = UsdzLibraryService.shared
    
    
    // MARK: Private - Methods
    
    private func generateLocalLibraryObjectViewModels(usdzObjects: [UsdzObjectWrapper]) {
        let localLibraryObjectViewModels = usdzObjects.map { (usdzObjectWrapper: UsdzObjectWrapper) -> LibraryObjectViewModel in
            
            LibraryObjectViewModel(
                usdzObjectWrapper: usdzObjectWrapper,
                onFavorite: { [weak self] usdzObject in self?.onFavoriteItem(usdzObject: usdzObject) },
                didProduceError: { [weak self] error in
                    self?.isAlertPresented = true
                    
                },
                onDismiss: { [weak self] in
                    self?.shouldDismiss = true
                }
            )
        
        }
        isLoadingList.toggle()
        self.localLibraryObjectViewModels = localLibraryObjectViewModels
        
    }
    

}




