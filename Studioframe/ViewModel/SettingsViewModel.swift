import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var showClearAllFavoritesAlert = false
    @Published var showClearAllDownloadedFilesAlert = false
    
    @Published var isErrorAlertPresented = false
    
    func clearAllFavorite() {
        do {
            try usdzLibraryService.deleteAllFavorite()
        } catch {
            isErrorAlertPresented.toggle()
        }
    }
    
    func clearAllDownloadAndFavorite() {
        do {
            try usdzLibraryService.clearAllDownloadAndFavorite()
        } catch {
            isErrorAlertPresented.toggle()
        }
    }
    
    private let usdzLibraryService = UsdzLibraryService.shared
}
