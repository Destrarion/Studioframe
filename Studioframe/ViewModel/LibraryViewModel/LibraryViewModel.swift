//
//  Main.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import Foundation
import SwiftUI

enum LibraryFilterOption {
    case all, favorited, downloaded
}

@MainActor
final class LibraryViewModel: ObservableObject {
    
    
    // MARK: - INTERNAL
    
    // MARK: Internal - Properties
    
    @Published var isAlertPresented = false
    @Published var searchText = ""
    @Published var currentLibraryFilterOption: LibraryFilterOption = .all
    @Published var localLibraryObjectViewModels: [LibraryObjectViewModel] = []
    @Published var isLoadingList: Bool = false
    @Published var shouldDismiss = false
    
    
    /// Filtered librart depending on the research and the option
    var filteredLocalLibraryObjectViewModels: [LibraryObjectViewModel] {
        let libaryObjectViewModelsFilterdOption = getLibraryObjectViewModelsAfterFilterOption()
        guard !searchText.isEmpty else {
            return libaryObjectViewModelsFilterdOption
        }
        
        
        let searchTextFiltered = libaryObjectViewModelsFilterdOption.filter { viewModel in
            viewModel.name
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .contains(
                    searchText
                        .lowercased()
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                )
        }
        
        return searchTextFiltered
    }
    
    /// function to research usdz depending on their category when we clicked a filter in library
    private func getLibraryObjectViewModelsAfterFilterOption() -> [LibraryObjectViewModel] {
        switch currentLibraryFilterOption {
        case .all:
            return localLibraryObjectViewModels
        case .favorited:
            return localLibraryObjectViewModels.filter { viewModel in
                return viewModel.isFavorited
            }
        case .downloaded:
            return localLibraryObjectViewModels.filter { viewModel in
                viewModel.downloadState == .downloaded
            }
        }
    }
    
    
    // MARK: Internal - Methods
    
    /// Fetch usdz on the server and generate viewmodel for each usdz
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

    /// button to make the USDZ favorite
    func onAddFavoriteItem(usdzObject: UsdzObject) {
        usdzLibraryService.addFavorite(usdzObject: usdzObject)
        print("Item favorited with name: \(usdzObject.title)")
    }
    
    /// button to remove the USDZ favorite
    func onRemoveFavoriteItem(usdzObject: UsdzObject){
        print("❌❌❌On Remove Favorite Item \(usdzObject.title)")
        usdzLibraryService.removeFavorite(usdzObject: usdzObject)
    }
    
    func onFavoriteItem(usdzObject: UsdzObjectWrapper){
        let usdzCheckFavorite = usdzLibraryService.checkFavorite(usdzobject: usdzObject.usdzObject)
        if usdzCheckFavorite == true {
            onRemoveFavoriteItem(usdzObject: usdzObject.usdzObject)
        } else {
            onAddFavoriteItem(usdzObject: usdzObject.usdzObject)
        }
        
        fetchObjects()
    }
    
    
    // MARK: - PRIVATE
    
    // MARK: Private - Properties
    
    
    private let usdzLibraryService = UsdzLibraryService.shared
    
    
    // MARK: Private - Methods
    
    private func generateLocalLibraryObjectViewModels(usdzObjects: [UsdzObjectWrapper]) {
        let localLibraryObjectViewModels = usdzObjects.map { (usdzObjectWrapper: UsdzObjectWrapper) -> LibraryObjectViewModel in
            
            LibraryObjectViewModel(
                usdzObjectWrapper: usdzObjectWrapper,
                onFavorite: { [weak self] usdzObject in self?.onFavoriteItem(usdzObject: usdzObjectWrapper) },
                onRemove: { [weak self] _ in self?.fetchObjects() },
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




