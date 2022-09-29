//
//  URLComponent.swift
//  Studioframe
//
//  Created by Fabien Dietrich.
//
import Foundation

protocol StudioframeUrlProviderProtocol {
    func createUsdzListRequestUrl() -> URL?
}

/// Main class to create the URL for fetching API.
final class StudioframeUrlProvider: StudioframeUrlProviderProtocol {
    
    static let shared = StudioframeUrlProvider()
    
    
    /// https://studioframeserver.herokuapp.com//usdz-objects
    // let url = URL(string: "http://127.0.0.1:8080/usdz-objects")! (local configuration)
    func createUsdzListRequestUrl() -> URL? {
        
        guard var urlComponents = URLComponents(url: configurationService.configurationType.schemeWithHostAndPort, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.path = "/usdz-objects"
        urlComponents.queryItems = nil
        
        return urlComponents.url
    }
    
    private let configurationService = ConfigurationService.shared

}
