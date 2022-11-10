//
//  LibraryObjectDownloadedViewModel.swift
//  Studioframe
//
//  Created by Sylvain Dietrich on 27/04/2022.
//

import Foundation
import Mixpanel


enum TrackingEvent {
    case addFavorite
    case downloadUsdz
    case removeUsdz
    case stopDownloadUsdz
    
    
    var title: String {
        switch self {
        case .addFavorite:
            return "Add Favorite"
        case .downloadUsdz:
            return "Download USDZ"
        case .removeUsdz:
            return "Removed USDZ"
        case .stopDownloadUsdz:
            return "Stopped downloading Usdz"
        }
    }
    
    var properties: [String: any MixpanelType] {
        switch self {
        case .addFavorite:
            return [:]
        case .downloadUsdz:
            return [:]
        case .removeUsdz:
            return [:]
        case .stopDownloadUsdz:
            return [:]
        }
    }
}

final class TrackingService {
    static let shared = TrackingService()
    
    private let mixpanelInstance: MixpanelInstance
    
    init() {
        Mixpanel.initialize(token: "d4d00a48e60230a09f1d45159daa6ea9", trackAutomaticEvents: true)
        self.mixpanelInstance = Mixpanel.mainInstance()
    }
    
    
    func track(event: TrackingEvent) {
        mixpanelInstance.track(
            event: event.title,
            properties: event.properties
        )
    }
    
    
    
}

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
    
    var name: String {
        usdzObjectWrapper.usdzObject.title
    }
    
    
    @Published var downloadState: LibraryObjectDownloadState = .notDownloaded
    
    var thumbnailImageUrl: URL? {
        configurationService.configurationType.schemeWithHostAndPort.appendingPathComponent(usdzObjectWrapper.usdzObject.thumbnailImageUrlString)
    }
    
    @Published var downloadProgress: Int = 0
    
    
    @Published var isQuickLookPresented = false
    
    var isFavorited: Bool {
        usdzObjectWrapper.isFavorited
    }
    
    
    
    let usdzObjectWrapper: UsdzObjectWrapper
    
    
    private let onFavorite: (UsdzObject) -> Void
    private let onRemove: (UsdzObject) -> Void
    private let didProduceError: (Error) -> Void
    private let onDismiss: () -> Void
    
    private let trackingService: TrackingService
    
    
    
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
    
    
    private let usdzLibraryService = UsdzLibraryService.shared
    private let studioFrameFileManager = StudioFrameFileManager.shared
    private let configurationService = ConfigurationService.shared
    
    
    private func downloadItem(usdzObject: UsdzObject) {
        Task {
            print("Item selected with name: \(usdzObject.title)")
            guard let _ = try? await usdzLibraryService.downloadUsdzObject(
                usdzObject: usdzObject,
                onDownloadProgressChanged: { [weak self] downloadProgress in
                    DispatchQueue.main.async { [weak self] in // TECHDEBT: Xcode 14 provide runtime error if not dispatching to the main queue, main actor issue?
                        self?.downloadProgress = downloadProgress
                    }
                }
            ) else {
                didProduceError(LibraryObjectViewModelError.failedToDownload)
                updateDownloadState()
                return
            }
            
            updateDownloadState()
            
        }
    }
    
    var downloadedUsdzObjectUrl: URL? {
        guard downloadState == .downloaded else { return nil }
        return try? studioFrameFileManager.getFileUrl(fileName: usdzObjectWrapper.usdzObject.objectUrlString)
    }
    
    
    
    private func removeLocalObject() {
        //guard let url = usdzLibraryService.urlPathUsdzObjects[usdzObject.title] else { return print("Error finding url for removing")}
        
        usdzLibraryService.remove(usdzObject: usdzObjectWrapper.usdzObject)
        updateDownloadState()
        print("Item removed with name: \(usdzObjectWrapper.usdzObject.title)")
        onRemove(usdzObjectWrapper.usdzObject)
    }
    
    
    
    private func updateDownloadState() {
        let isDownloaded = usdzLibraryService.getIsDownload(usdzObject: usdzObjectWrapper.usdzObject)
        self.downloadState = isDownloaded ? .downloaded : .notDownloaded
    }
    
}

enum LibraryObjectViewModelError: Error {
    case failedToDownload
}


