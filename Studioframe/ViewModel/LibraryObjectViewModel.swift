//
//  LibraryObjectDownloadedViewModel.swift
//  Studioframe
//
//  Created by Sylvain Dietrich on 27/04/2022.
//

import Foundation


enum LibraryObjectDownloadState {
    case notDownloaded
    case downloading
    case downloaded
}

@MainActor
final class LibraryObjectViewModel: ObservableObject {
    
    init(
        usdzObjectWrapper: UsdzObjectWrapper,
        onFavorite: @escaping (UsdzObject) -> Void,
        didProduceError: @escaping (Error) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.usdzObjectWrapper = usdzObjectWrapper
        self.onFavorite = onFavorite
        self.didProduceError = didProduceError
        self.onDismiss = onDismiss
        
        self.updateDownloadState()
    }
    
    var name: String {
        usdzObjectWrapper.usdzObject.title
    }
    
    
//    if UsdzLibraryService.shared.downloadedUsdzObjects[viewModel.name] == true {
//        FileDownloadedView(viewModel: viewModel)
//    } else {
//        FileNotDowloadedView(viewModel: viewModel)
//    }
//
    @Published var downloadState: LibraryObjectDownloadState = .notDownloaded
    
    var thumbnailImageUrl: URL? {
        configurationService.configurationType.schemeWithHostAndPort.appendingPathComponent(usdzObjectWrapper.usdzObject.thumbnailImageUrlString)
    }
    
    @Published var downloadProgress: Int = 0
    
    
    @Published var isQuickLookPresented = false
    
    
    
    
    let usdzObjectWrapper: UsdzObjectWrapper
    
    
    private let onFavorite: (UsdzObject) -> Void
    private let didProduceError: (Error) -> Void
    private let onDismiss: () -> Void
    
    
    
    func didTapSelect() {
        guard let donwloadedUsdzObjectUrl = donwloadedUsdzObjectUrl else { return }
        NotificationCenter.default.post(name: .shouldAddUsdzObject, object: donwloadedUsdzObjectUrl)
        onDismiss()
    }
    
    func didTapFavorite() {
        onFavorite(usdzObjectWrapper.usdzObject)
    }
    
    
    func didTapRemove() {
        removeLocalObject()
    }
    
    
    func didTapDownload() {
        downloadState = .downloading
        downloadItem(usdzObject: usdzObjectWrapper.usdzObject)
    }
    
    func didTapStopDownload() {
        downloadState = .notDownloaded
    }
    
//    func isDownloadedUsdz(usdzObject: UsdzObject) -> Bool{
//        if usdzObjectWrapper.isDownloaded {
//            downloadState = .downloaded
//            return true
//        }
//        return false
//    }
//
    
    private let usdzLibraryService = UsdzLibraryService.shared
    private let studioFrameFileManager = StudioFrameFileManager.shared
    private let configurationService = ConfigurationService.shared
    

    private func downloadItem(usdzObject: UsdzObject) {
        Task {
            print("Item selected with name: \(usdzObject.title)")
            guard let _ = try? await usdzLibraryService.downloadUsdzObject(
                usdzObject: usdzObject,
                onDownloadProgressChanged: { [weak self] downloadProgress in self?.downloadProgress = downloadProgress }
            ) else {
                didProduceError(LibraryObjectViewModelError.failedToDownload)
                updateDownloadState()
                return
            }
           
            updateDownloadState()
            
        }
    }
    
    var donwloadedUsdzObjectUrl: URL? {
        guard downloadState == .downloaded else { return nil }
        return try? studioFrameFileManager.getFileUrl(fileName: usdzObjectWrapper.usdzObject.objectUrlString)
    }
    
    
    
    private func removeLocalObject() {
        //guard let url = usdzLibraryService.urlPathUsdzObjects[usdzObject.title] else { return print("Error finding url for removing")}
        
        usdzLibraryService.remove(usdzObject: usdzObjectWrapper.usdzObject)
        updateDownloadState()
        print("Item removed with name: \(usdzObjectWrapper.usdzObject.title)")
    }
    
    
    
    private func updateDownloadState() {
        let isDownloaded = usdzLibraryService.getIsDownload(usdzObject: usdzObjectWrapper.usdzObject)
        self.downloadState = isDownloaded ? .downloaded : .notDownloaded
    }
    
}

enum LibraryObjectViewModelError: Error {
    case failedToDownload
}


