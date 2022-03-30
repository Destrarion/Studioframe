//
//  UsdzLibraryService.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 24/03/2022.
//

import Foundation


final class UsdzLibraryService {
    
    static let shared = UsdzLibraryService()
    let urlProvider = StudioframeUrlProvider()
    
    func fetchUsdzObjects() async throws -> [UsdzObject] {
        //let url = URL(string: "https://studioframeserver.herokuapp.com/usdz-objects")!
        guard let url = urlProvider.createUsdzListRequestUrl() else { return [] }
        let urlRequest = URLRequest(url: url)
        
        let usdzObjects: [UsdzObject] = try await networkManager.fetch(urlRequest: urlRequest)
        return usdzObjects
    }
    
    
    /// Download the specified usdz object and store it locally
    /// - Parameter usdzObject: Object containing the url pointing to the file web location
    /// - Returns: The local URL of the downloaded USDZ object
    func downloadUsdzObject(usdzObject: UsdzObject) async throws -> URL {

        // let url = URL(string: "http://127.0.0.1:8080/" + usdzObject.objectUrlString)! (local configuration)
        let url = URL(string: "https://studioframeserver.herokuapp.com/" + usdzObject.objectUrlString)!
        
        let urlRequest = URLRequest(url: url)
        
        let usdzObjectLocalFileUrl: URL = try await networkManager.fetchFile(urlRequest: urlRequest)
        let newLocationUrl = getDocumentsDirectory().appendingPathComponent(usdzObject.objectUrlString)
        
        do {
            try FileManager.default.copyItem(at: usdzObjectLocalFileUrl, to: newLocationUrl)
        } catch {
            print("FAILED TO COPY USDZ FILE")
            print(error)
            throw UsdzLibraryServiceError.failedToDownloadUsdzObject
        }
        
        return newLocationUrl
    }
    
    
    
    
    private func getHostUrl() -> URL {
        return URL(string: "")!
    }
    
    
    
    
    
    
    
    /// Singleton of the network manager
    private let networkManager = NetworkManager.shared
    
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
