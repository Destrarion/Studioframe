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
    
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        urlProvider: StudioframeUrlProviderProtocol = StudioframeUrlProvider()
    ){
        self.networkManager = networkManager
        self.urlProvider = urlProvider
        
        addAirForceFavorite()
    }
    
    
    ///function to stop the dowload of the usdz
    func stopDownload(usdzObject: UsdzObject) {
        let url = URL(string: "https://studioframeserver.herokuapp.com/" + usdzObject.objectUrlString)!
        networkManager.stopDownload(url: url)
    }
    
    /// fetch usdz on the server and rethrieve all usdz info (not downloaded yet)
    func fetchUsdzObjects() async throws -> [UsdzObjectWrapper] {
        //let url = URL(string: "https://studioframeserver.herokuapp.com/usdz-objects")!
        /// Choose here between local or heroku server for the request
        guard let url = urlProvider.createUsdzListRequestUrl() else { return [] }
        let urlRequest = URLRequest(url: url)
        
        let usdzObjects: [UsdzObject] = try await networkManager.fetch(urlRequest: urlRequest)
        
        /// check if we already downloaded the usdz for the view
        let allLocalFilesTitles = try studioFrameFileManager.getAllFileTitlesInDocumentsDirectory()
        
        
        let newObjects : [UsdzObjectWrapper] = usdzObjects.map { newObject in
            print(allLocalFilesTitles.description.contains(newObject.objectUrlString))
            
            
            let isFavorited = checkFavorite(usdzobject: newObject)
            
            return UsdzObjectWrapper(
                usdzObject: newObject,
                isDownloaded: allLocalFilesTitles.description.contains(newObject.objectUrlString),
                isFavorited:  isFavorited // TODO: should handle favoriting
            )
            
        }
        print("the new object are : \(newObjects)")
        
        return newObjects
    }
    
    /// get all the local usdz in the file
    func getLocalObjects() throws -> [UsdzObject] {
        let allLocalFilesUrls = try studioFrameFileManager.getAllFileTitlesInDocumentsDirectory()
        let usddObjects = allLocalFilesUrls.map { url -> UsdzObject in
            let title = url.pathComponents.last!.split(separator: ".").first!.description
            let object = UsdzObject(
                title: title,
                objectUrlString: url.absoluteString,
                thumbnailImageUrlString: ""
            )
            return object
        }
        
        return usddObjects
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
            removeFavorite(usdzObject: usdzObject)
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
    
    
    
    func getFavoriteObjects() -> [UsdzObject] {
        return coreDataManager.getItems()
    }
    
    func addFavorite(usdzObject: UsdzObject) {
        coreDataManager.addItem(usdz: usdzObject)
    }
    
    func removeFavorite(usdzObject: UsdzObject) {
        coreDataManager.deleteItem(with: usdzObject)
    }
    
    func deleteAllFavorite(){
        coreDataManager.deleteAllItems()
    }
    
    func checkFavorite(usdzobject: UsdzObject) -> Bool{
        let favoritedUsdzObjects = getFavoriteObjects()
        
        let isFavorited = favoritedUsdzObjects.contains { favoritedUsdzObject in
            favoritedUsdzObject.title == usdzobject.title
        }
        return isFavorited
    }
    
    private func addAirForceFavorite(){
        let airForce = try? studioFrameFileManager.getFileUrl(fileName: "AirForce")
        let favoriteObject = getFavoriteObjects()
        print(favoriteObject.description)
        print(String(describing: airForce))
        let isFavorited = favoriteObject.contains { favoriteObject in
            favoriteObject.objectUrlString.split(separator: "/").last?.description == airForce?.pathComponents.last?.split(separator: "/").last?.description
        }
        if isFavorited == false {
            coreDataManager.addItem(usdz: UsdzObject.init(title: "AirForce", objectUrlString: "\(airForce?.description ?? "")", thumbnailImageUrlString: ""))
        }
    }
    
    /// Singleton of the network manager
    private let networkManager : NetworkManagerProtocol
    private let urlProvider: StudioframeUrlProviderProtocol
    private let studioFrameFileManager = StudioFrameFileManager.shared
    private let coreDataManager = UsdzCoreDataManager.shared
    

}
