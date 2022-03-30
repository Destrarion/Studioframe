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
    
    /// Create a URL fitting with the HTML with the ingredient
    ///
    /// Using urlComponent to create the URL
    ///
    /// 1.  Creating the URL components, we add :
    ///     * Scheme = The scheme subcomponent of the URL.
    ///     * Host = The host subcomponent.
    ///     * Path = The path subcomponent.
    ///
    ///     And the Query items :
    ///
    /// 2. Then it return the urlComponents.url
    ///
    /// - Returns: URL created with URLComponents ( urlComponents.url )
    func createUsdzListRequestUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "studioframeserver.herokuapp.com"
        urlComponents.path = "/usdz-objects"
        urlComponents.queryItems = []
        
        return urlComponents.url
    }
    
    // let url = URL(string: "http://127.0.0.1:8080/usdz-objects")! (local configuration)
    func createLocalUsdzListRequestUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "127.0.0.1:8080"
        urlComponents.path = "/usdz-objects"
        urlComponents.queryItems = []
        
        return urlComponents.url
    }
}
