import Foundation
import UIKit
import QuickLook

enum QuickLookViewControllerError {
    case failtoloadItem
}

final class QuickLookViewController: QLPreviewController {
    
    init(objectUrl: URL) {
        self.objectUrl = objectUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("QuickLookViewController from storyboard not implemented")
    }
    
    private let objectUrl: URL
    
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
        return objectUrl as QLPreviewItem
    }
}



class PlaceholderPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    
    
    var previewItemTitle: String? = "Failed to load"
}

