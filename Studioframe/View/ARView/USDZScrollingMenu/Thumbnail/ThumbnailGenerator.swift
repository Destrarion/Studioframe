import SwiftUI
import QuickLookThumbnailing

class ThumbnailGenerator: ObservableObject {
    
    static let shared = ThumbnailGenerator()
    
    
    // MARK: Other version
    
    func getThumbnail(fileURL: String, size: CGSize) async -> Image? {
        guard let cacheThumbnail = thumbnailCache[fileURL] else {
            return await generateThumbnail(urlFile: fileURL, size: size)
        }
        
        return cacheThumbnail
    }
    
    
    private func generateThumbnail(urlFile : String, size: CGSize) async -> Image? {
        
        let scale = await UIScreen.main.scale
        
        guard let url = URL(string: urlFile) else {
            return nil
        }
        
  
        
        let image: Image? = await withCheckedContinuation { continuation in
            let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
            let generator = QLThumbnailGenerator.shared
            
            generator.generateBestRepresentation(for: request) { (thumbnail, error)  in
                
                guard let thumbnail = thumbnail,
                      error == nil else {
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
