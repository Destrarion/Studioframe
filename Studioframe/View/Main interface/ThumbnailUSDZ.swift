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
    
    func generateThumbnail(for ressource: String, withExtension : String = "usdz", size: CGSize) async -> Image? {
        guard let url = Bundle.main.url(forResource: ressource, withExtension: withExtension) else {
            print("Unable to create URL for ressource.")
            return nil
        }
        
        let scale = await UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
        
        let generator = QLThumbnailGenerator.shared
        
        
        
        return await withCheckedContinuation { continuation in
            generator.generateBestRepresentation(for: request) { (thumbnail, error)  in
                
                if thumbnail == nil || error != nil {
                    print("Error generating thumbnail: \(error?.localizedDescription ?? "Error generating thumbnail")")
                    continuation.resume(returning: nil)
                    return
                }
                else {
                    continuation.resume(returning: Image(uiImage: thumbnail!.uiImage))
                    return
                }
                
            }
        }
        
       
    }
    
}
