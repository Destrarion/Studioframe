//
//  UsdzLibraryService.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 24/03/2022.
//

import Foundation
import SwiftUI

final class UsdzLibraryService {
    
    static let shared = UsdzLibraryService()
    let urlProvider = StudioframeUrlProvider()
    
    //var downloadedUsdzObjects: [String : Bool] = [:]
    //var urlPathUsdzObjects: [String : URL] = [:]
    
    func fetchUsdzObjects() async throws -> [UsdzObjectWrapper] {
        //let url = URL(string: "https://studioframeserver.herokuapp.com/usdz-objects")!
        /// Choose here between local or heroku server for the request
        guard let url = urlProvider.createLocalUsdzListRequestUrl() else { return [] }
        let urlRequest = URLRequest(url: url)
        
        let usdzObjects: [UsdzObject] = try await networkManager.fetch(urlRequest: urlRequest)
        
        
        let allLocalFilesTitles = try studioFrameFileManager.getAllFileTitlesInDocumentsDirectory()
        
        let newObject : [UsdzObjectWrapper] = usdzObjects.map {
            print(allLocalFilesTitles.description.contains($0.objectUrlString))
            return UsdzObjectWrapper(usdzObject: $0, isDownloaded: allLocalFilesTitles.description.contains($0.objectUrlString) )
            
        }
        print("the new object is : \(newObject)")
        
//        usdzObjects.forEach { object in
//            downloadedUsdzObjects[object.title] = false
//            print(downloadedUsdzObjects)
//        }
        
        return newObject
    }
    

    
    /// Download the specified usdz object and store it locally
    /// - Parameter usdzObject: Object containing the url pointing to the file web location
    /// - Returns: The local URL of the downloaded USDZ object
    func downloadUsdzObject(usdzObject: UsdzObject, onDownloadProgressChanged: @escaping (Int) -> Void) async throws -> URL {
        
        
        // let url = URL(string: "http://127.0.0.1:8080/" + usdzObject.objectUrlString)! (local configuration)
        let url = URL(string: "https://studioframeserver.herokuapp.com/" + usdzObject.objectUrlString)!
        
        let urlRequest = URLRequest(url: url)
        
        
        return try await withCheckedThrowingContinuation { (continuation:  CheckedContinuation<URL, Error>) in
            networkManager.fetchFile(urlRequest: urlRequest, onDownloadProgressChanged: onDownloadProgressChanged) { [weak self] usdzObjectLocalFileUrl in
                guard let self = self else {
                    continuation.resume(throwing: UsdzLibraryServiceError.failedToDownloadUsdzObject)
                    return
                }
                
                do {
                    let newLocationUrl = try self.studioFrameFileManager.moveFile(at: usdzObjectLocalFileUrl, fileName: usdzObject.objectUrlString)
                    
                    //self.urlPathUsdzObjects ["\(usdzObject.title)"] = newLocationUrl
                    print("New Location : \(newLocationUrl)")
                    print("⚠️ Successfuly stored USDZ")
                    continuation.resume(returning: newLocationUrl)
                    return
                } catch {
                    print("FAILED TO COPY USDZ FILE")
                    print(error)
                    continuation.resume(throwing: UsdzLibraryServiceError.failedToDownloadUsdzObject)
                    return
                }
                
                
            }
        }
        
    }
    
    func remove(usdzObject: UsdzObject) {
        
        do {
            try studioFrameFileManager.removeFileFromDocumentsDirectiory(fileName:  usdzObject.objectUrlString)
            print("try to remove item at \(usdzObject.objectUrlString)")
        } catch {
            print(error)
            print("Error removing item \(usdzObject.objectUrlString)")
        }
    }
    
    func getIsDownload(usdzObject: UsdzObject) -> Bool {
        guard let allFileTitles = try? studioFrameFileManager.getAllFileTitlesInDocumentsDirectory() else {
            return false
        }
        
        
        
        // FIXME: should not work like that
        let isDownloaded = allFileTitles.contains { url in
            url.absoluteString.contains(usdzObject.objectUrlString)
        }
        
        
        return isDownloaded
    }
    
    
    private func getHostUrl() -> URL {
        return URL(string: "")!
    }
    
    
    /// Singleton of the network manager
    private let networkManager = NetworkManager.shared
    private let studioFrameFileManager = StudioFrameFileManager.shared
    

}
