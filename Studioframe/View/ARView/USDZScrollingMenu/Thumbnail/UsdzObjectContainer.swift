//
//  UsdzObjectContainer.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import SwiftUI



@MainActor
class UsdzObjectContainer: ObservableObject, Identifiable {
    private let thumbnailGenerator = ThumbnailGenerator.shared
    
    init(fileName: String) {
        self.fileName = fileName
        
        loadThumbnailImage()
    }
    
    private func loadThumbnailImage() {
        Task {
            isLoading.toggle()
            self.image = await thumbnailGenerator.getThumbnail(for: fileName, size: CGSize(width: 400, height: 400))
            isLoading.toggle()
        }
    }
    
    let id = UUID()
    let fileName: String
   
    @Published var image: Image?
    @Published var isLoading = false
    
}

