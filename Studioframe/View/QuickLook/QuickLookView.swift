import Foundation
import SwiftUI





struct QuickLookView: UIViewControllerRepresentable {
    
    init(objectUrl: URL) {
        self.objectUrl = objectUrl
    }
    
    let objectUrl: URL
    
    func makeUIViewController(context: Context) -> some QuickLookViewController {
        QuickLookViewController(objectUrl: objectUrl)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
