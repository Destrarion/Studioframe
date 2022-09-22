//
//  UsdzObjectContainer.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import SwiftUI


// TEST COMMIT PUSH GITHUB ACTIONS => To be removed

@MainActor
class UsdzObjectContainer: ObservableObject, Identifiable {
    private let thumbnailGenerator = ThumbnailGenerator.shared
    
    init(fileName: String, fileUrl: String) {
        self.fileName = fileName
        self.fileURL = fileUrl
        
        loadThumbnailImage()
    }
    
    @Published var image: Image?
    @Published var isLoading = false
    let id = UUID()
    let fileName: String
    let fileURL: String 
    
    private func loadThumbnailImage() {
        Task {
            isLoading.toggle()
            print(fileName)
            print(fileURL)
            self.image = await thumbnailGenerator.getThumbnail(fileURL: fileURL, size: CGSize(width: 400, height: 400))
            isLoading.toggle()
        }
    }
    
   
}

