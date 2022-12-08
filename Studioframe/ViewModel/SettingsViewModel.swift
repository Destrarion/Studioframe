//
//  SettingsViewModel.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 20/10/2022.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    func clearAllFavorite() {
        usdzLibraryService.deleteAllFavorite()
    }
    func clearAllDownload() {
        usdzLibraryService.clearAllDownload()
    }
    
    private let usdzLibraryService = UsdzLibraryService.shared
}
