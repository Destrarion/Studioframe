//
//  URLComponent.swift
//  Studioframe
//
//  Created by Fabien Dietrich.
//
import Foundation

protocol StudioframeUrlProviderProtocol {
}

/// Main class to create the URL for fetching API.
final class StudioframeUrlProvider: StudioframeUrlProviderProtocol {
    
    static let shared = StudioframeUrlProvider()
    
    /// https://studioframeserver.herokuapp.com//usdz-objects
    // let url = URL(string: "http://127.0.0.1:8080/usdz-objects")! (local configuration)
    func createUsdzListRequestUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = configurationService.configurationType.scheme
        urlComponents.host = configurationService.configurationType.host
        urlComponents.port = configurationService.configurationType.port
        urlComponents.path = "/usdz-objects"
        urlComponents.queryItems = nil
        
        return urlComponents.url
    }
    
    private let configurationService = ConfigurationService.shared

}


final class ConfigurationService {
    static let shared = ConfigurationService()
    private init() { }
    
    var configurationType: ConfigurationType {
#if Local 
        return .local
#elseif Heroku
        return .heroku
#else
        return .local
#endif
    }
}

enum ConfigurationType {
    case local
    case heroku
    
    var scheme: String {
        switch self {
        case .local:
            return "http"
        case .heroku:
            return "https"
        }
    }
    
    var port: Int? {
        switch self {
        case .local:
            return 8080
        case .heroku:
            return nil
        }
    }
    
    var host: String {
        switch self {
        case .local:
            return "127.0.0.1"
        case .heroku:
            return "studioframeserver.herokuapp.com"
        }
    }
}
