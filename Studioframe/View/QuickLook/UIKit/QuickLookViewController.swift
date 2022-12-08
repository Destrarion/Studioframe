//
//  QuickLookViewController.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 19/05/2022.
//

import Foundation
import UIKit
import QuickLook



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
        let previewItem = objectUrl! as QLPreviewItem
        
        return previewItem
    }
}
