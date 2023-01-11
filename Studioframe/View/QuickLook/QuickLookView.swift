import Foundation
import SwiftUI





struct QuickLookView: UIViewControllerRepresentable {
    
    init(objectUrl: URL) {
        self.objectUrl = objectUrl
    }
    
    let objectUrl: URL
    
    func makeUIViewController(context: Context) -> some QuickLookViewController {
        let quickLookViewController = QuickLookViewController()
        quickLookViewController.objectUrl = objectUrl
        return quickLookViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
