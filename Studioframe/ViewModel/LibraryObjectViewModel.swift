import Foundation


enum LibraryObjectDownloadState {
    case notDownloaded
    case downloading
    case downloaded
}

@MainActor
final class LibraryObjectViewModel: ObservableObject {
    init(
        usdzObject: UsdzObject,
        onSelect: @escaping (UsdzObject) -> Void,
        onRemove: @escaping (UsdzObject) -> Void,
        onFavorite: @escaping (UsdzObject) -> Void,
        didProduceError: @escaping (Error) -> Void
    ) {
        self.usdzObject = usdzObject
        self.onSelect = onSelect
        self.onRemove = onRemove
        self.onFavorite = onFavorite
        self.didProduceError = didProduceError
    }
    
    var name: String {
        usdzObject.title
    }
    
//    if UsdzLibraryService.shared.downloadedUsdzObjects[viewModel.name] == true {
//        FileDownloadedView(viewModel: viewModel)
//    } else {
//        FileNotDowloadedView(viewModel: viewModel)
//    }
    
    @Published var downloadState: LibraryObjectDownloadState = .notDownloaded
    
    @Published var imageName: String = ""
    @Published var downloadProgress: Int = 0
    
    
    
    
    
    let usdzObject: UsdzObject
    
    private let onSelect: (UsdzObject) -> Void
    private let onRemove: (UsdzObject) -> Void
    private let onFavorite: (UsdzObject) -> Void
    
    private let didProduceError: (Error) -> Void
    
    func didTapSelect() {
        onSelect(usdzObject)
    }
    
    func didTapRemove() {
        downloadState = .notDownloaded
        onRemove(usdzObject)
    }
    
    func didTapFavorite() {
        onFavorite(usdzObject)
    }
    
    func didTapDownload() {
        downloadState = .downloading
        downloadItem(usdzObject: usdzObject)
    }
    
    func didTapStopDownload() {
        downloadState = .notDownloaded
    }
    
    func isDownloadedUsdz(usdzObject: UsdzObject) -> Bool{
        if usdzLibraryService.downloadedUsdzObjects[usdzObject.title] == true {
            return true
        }
        return false
    }
    
    
    
    private let usdzLibraryService = UsdzLibraryService.shared
    
    private func downloadItem(usdzObject: UsdzObject) {
        Task {
            print("Item selected with name: \(usdzObject.title)")
            guard let donwloadedUsdzObjectUrl = try? await usdzLibraryService.downloadUsdzObject(
                usdzObject: usdzObject,
                onDownloadProgressChanged: { [weak self] downloadProgress in self?.downloadProgress = downloadProgress }
            ) else {
                didProduceError(LibraryObjectViewModelError.failedToDownload)
                downloadState = .notDownloaded
                return
            }
            downloadState = .downloaded
            NotificationCenter.default.post(name: .shouldAddUsdzObject, object: donwloadedUsdzObjectUrl)
            
        }
    }
    
}


enum LibraryObjectViewModelError: Error {
    case failedToDownload
}
