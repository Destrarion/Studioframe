//
//  LocalLibraryObjectViewModel.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 21/02/2022.
//

import Foundation

final class LocalLibraryObjectViewModel: ObservableObject {
    init(
        name: String,
        imageName: String,
        onSelect: @escaping (String) -> Void,
        onRemove: @escaping (String) -> Void,
        onFavorite: @escaping (String) -> Void
    ) {
        self.name = name
        self.imageName = imageName
        self.onSelect = onSelect
        self.onRemove = onRemove
        self.onFavorite = onFavorite
    }
    
    let name: String
    @Published var imageName: String
    
    private let onSelect: (String) -> Void
    private let onRemove: (String) -> Void
    private let onFavorite: (String) -> Void
    
    func didSelect() {
        onSelect(name)
    }
    
    func didRemove() {
        onRemove(name)
    }
    
    func didFavorite() {
        onFavorite(name)
    }
}
