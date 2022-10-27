//
//  ThumbnailUSDZ.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 09/02/2022.
//

import SwiftUI
import QuickLookThumbnailing
import Combine


class ThumbnailGenerator: ObservableObject {
    
    static let shared = ThumbnailGenerator()
    var usdzLibraryService = UsdzLibraryService.shared
    
    
    // MARK: Other version
    
    func getThumbnail(fileURL: String, size: CGSize) async -> Image? {
        
        
        print(thumbnailCache)
        
        //guard let cacheThumbnail = thumbnailCache[fileURL] else {
            return await generateThumbnail(urlFile: fileURL, size: size)
        //}
        
        //return cacheThumbnail
    }
    
    
    private func generateThumbnail(urlFile : String, size: CGSize) async -> Image? {
        
        let scale = await UIScreen.main.scale
        
        guard let url = URL(string: urlFile) else {
            print("could not convert string to URL for thumbnail")
            return nil
        }
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
        
        let generator = QLThumbnailGenerator.shared
        
        let image: Image? = await withCheckedContinuation { continuation in
            generator.generateBestRepresentation(for: request) { (thumbnail, error)  in
                
                guard let thumbnail = thumbnail,
                      error == nil else {
                          print("Error generating thumbnail: \(error?.localizedDescription ?? "Error generating thumbnail")")
                          continuation.resume(returning: nil)
                          return
                      }
                let image = Image(uiImage: thumbnail.uiImage)
                continuation.resume(returning: image)
            }
        }
        if let unwrappedImage = image {
            thumbnailCache[urlFile] = unwrappedImage
        }
        return image
    }
    
    
    private var thumbnailCache: [String:Image] = [:]
    
}
