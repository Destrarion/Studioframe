import SwiftUI



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
    var fileURL: String
    
    private var usdzLibraryService = UsdzLibraryService.shared
    
    func assignURLFile(title : String) {
        let local = try? usdzLibraryService.getLocalObjects()
        local?.forEach { usdz in
            if usdz.title == title {
                fileURL = usdz.objectUrlString
                
            }
        }
    }
    
    private func loadThumbnailImage() {
        Task {
            isLoading.toggle()
            assignURLFile(title: fileName)
            self.image = await thumbnailGenerator.getThumbnail(fileURL: fileURL, size: CGSize(width: 400, height: 400))
            isLoading.toggle()
        }
    }
    
   
}

