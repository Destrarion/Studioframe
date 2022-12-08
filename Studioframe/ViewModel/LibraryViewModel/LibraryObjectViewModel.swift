//
//  LibraryObjectDownloadedViewModel.swift
//  Studioframe
//
//  Created by Sylvain Dietrich on 27/04/2022.
//

import Foundation
import Mixpanel



@MainActor
final class LibraryObjectViewModel: ObservableObject {
    
    init(
        usdzObjectWrapper: UsdzObjectWrapper,
        onFavorite: @escaping (UsdzObject) -> Void,
        onRemove: @escaping (UsdzObject) -> Void,
        didProduceError: @escaping (Error) -> Void,
        onDismiss: @escaping () -> Void,
        trackingService: TrackingService = TrackingService.shared
    ) {
        self.usdzObjectWrapper = usdzObjectWrapper
        self.onFavorite = onFavorite
        self.onRemove = onRemove
        self.didProduceError = didProduceError
        self.onDismiss = onDismiss
        
        self.trackingService = trackingService
        
        self.updateDownloadState()
    }
    
    //MARK: - Internal - Published Var
    @Published var downloadState: LibraryObjectDownloadStateEnum = .notDownloaded
    @Published var downloadProgress: Int = 0
    @Published var isQuickLookPresented = false
    
    //MARK: Internal - Var
    var thumbnailImageUrl: URL? {
        configurationService.configurationType.schemeWithHostAndPort.appendingPathComponent(usdzObjectWrapper.usdzObject.thumbnailImageUrlString)
    }
    var isFavorited: Bool {
        usdzObjectWrapper.isFavorited
    }
    var downloadedUsdzObjectUrl: URL? {
        guard downloadState == .downloaded else { return nil }
        return try? studioFrameFileManager.getFileUrl(fileName: usdzObjectWrapper.usdzObject.objectUrlString)
    }
    var name: String {
        usdzObjectWrapper.usdzObject.title
    }
    
    //MARK: - Internal - Let
    let usdzObjectWrapper: UsdzObjectWrapper
    
    //MARK: - Internal - Function
    func didTapSelect() {
        guard let downloadedUsdzObjectUrl = downloadedUsdzObjectUrl else { return }
        NotificationCenter.default.post(name: .shouldAddUsdzObject, object: downloadedUsdzObjectUrl)
        onDismiss()
    }
    func didTapFavorite() {
        onFavorite(usdzObjectWrapper.usdzObject)
        trackingService.track(event: .addFavorite)
    }
    func didTapRemove() {
        removeLocalObject()
        trackingService.track(event: .removeUsdz)
    }
    func didTapDownload() {
        downloadState = .downloading
        downloadItem(usdzObject: self.usdzObjectWrapper.usdzObject)
        trackingService.track(event: .downloadUsdz)
    }
    func didTapStopDownload() {
        downloadState = .notDownloaded
        usdzLibraryService.stopDownload(usdzObject: usdzObjectWrapper.usdzObject)
        trackingService.track(event: .stopDownloadUsdz)
    }
    
    //MARK: - Private - Func
    private func downloadItem(usdzObject: UsdzObject) {
        Task {
            guard let _ = try? await usdzLibraryService.downloadUsdzObject(
                usdzObject: usdzObject,
                onDownloadProgressChanged: { [weak self] downloadProgress in
                    DispatchQueue.main.async { [weak self] in // TECHDEBT: Xcode 14 provide runtime error if not dispatching to the main queue, main actor issue?
                        self?.downloadProgress = downloadProgress
                    }
                }
            ) else {
                didProduceError(LibraryObjectViewModelErrorEnum.failedToDownload)
                updateDownloadState()
                return
            }
            
            updateDownloadState()
            
        }
    }
    private func removeLocalObject() {
        usdzLibraryService.removeDownload(usdzObject: usdzObjectWrapper.usdzObject)
        updateDownloadState()
        onRemove(usdzObjectWrapper.usdzObject)
    }
    private func updateDownloadState() {
        let isDownloaded = usdzLibraryService.getIsDownload(usdzObject: usdzObjectWrapper.usdzObject)
        self.downloadState = isDownloaded ? .downloaded : .notDownloaded
    }
    
    //MARK: - Private - Let
    private let usdzLibraryService = UsdzLibraryService.shared
    private let studioFrameFileManager = StudioFrameFileManager.shared
    private let configurationService = ConfigurationService.shared
    private let onFavorite: (UsdzObject) -> Void
    private let onRemove: (UsdzObject) -> Void
    private let didProduceError: (Error) -> Void
    private let onDismiss: () -> Void
    private let trackingService: TrackingService
}




