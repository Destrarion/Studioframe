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
    
    
    // MARK: Other version
    
    func getThumbnail(for ressource: String, withExtension: String = "usdz", size: CGSize) async -> Image? {
        guard let cacheThumbnail = thumbnailCache[ressource] else {
            return await generateThumbnail(for: ressource, size: size)
        }
        
        return cacheThumbnail
    }
    
    private func generateThumbnail(for ressource: String, withExtension: String = "usdz", size: CGSize) async -> Image? {
        guard let url = Bundle.main.url(forResource: ressource, withExtension: withExtension) else {
            print("Unable to create URL for ressource.")
            return nil
        }
        
        let scale = await UIScreen.main.scale
        
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
            thumbnailCache[ressource] = unwrappedImage
        }
        
        return image
       
    }
    
    
    
    private var thumbnailCache: [String:Image] = [:]
    
}
