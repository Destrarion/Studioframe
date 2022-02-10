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
    
    @Published var thumbnailImage : Image?
    
    func generateThumbnail(for ressource: String, withExtension : String = "usdz", size: CGSize){
        guard let url = Bundle.main.url(forResource: ressource, withExtension: withExtension) else {
            print("Unable to create URL for ressource.")
            return
        }
        
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
        
        let generator = QLThumbnailGenerator.shared
    
        generator.generateRepresentations(for: request) { (thumbnail, type, error)  in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    print("Error generating thumbnail: \(error?.localizedDescription ?? "Error generating thumbnail")")
                    return
                }
                else {
                    self.thumbnailImage = Image(uiImage: thumbnail!.uiImage)
                }
            }
        }
    }
    
}
