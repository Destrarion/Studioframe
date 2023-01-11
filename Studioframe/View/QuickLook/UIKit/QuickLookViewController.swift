import Foundation
import UIKit
import QuickLook

enum QuickLookViewControllerError {
    case failtoloadItem
}

final class QuickLookViewController: QLPreviewController {
    var objectUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
}

extension QuickLookViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let previewItem = objectUrl as? QLPreviewItem else {
            return PlaceholderPreviewItem()
        }
        
        return previewItem
    }
}



class PlaceholderPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    
    var previewItemTitle: String? = "Failed to load"
}
