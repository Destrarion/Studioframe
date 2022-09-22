//
//  QuickLookView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 19/05/2022.
//

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
