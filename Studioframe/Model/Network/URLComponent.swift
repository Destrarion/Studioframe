import Foundation

protocol StudioframeUrlProviderProtocol {
    func createUsdzListRequestUrl() -> URL?
    func createUsdzDownloadRequestUrl(name: String) -> URL?
}

/// Main class to create the URL for fetching API.
final class StudioframeUrlProvider: StudioframeUrlProviderProtocol {
    
    static let shared = StudioframeUrlProvider()
    
    
    func createUsdzListRequestUrl() -> URL? {
        
        guard var urlComponents = URLComponents(url: configurationService.configurationType.schemeWithHostAndPort, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.path = "/usdz-objects"
        urlComponents.queryItems = nil
        return urlComponents.url
    }
    
    func createUsdzDownloadRequestUrl(name: String ) -> URL? {
        guard var urlComponents = URLComponents(url: configurationService.configurationType.schemeWithHostAndPort, resolvingAgainstBaseURL: true) else {
            return URL(string: "failed")
        }
        urlComponents.path = "/\(name).usdz"
        urlComponents.queryItems = nil
        return urlComponents.url
    }
    
    private let configurationService = ConfigurationService.shared

}

enum StudioframeUrlProviderError : Error {
    case failconfigurationtype
}
