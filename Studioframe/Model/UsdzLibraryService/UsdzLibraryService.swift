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
    
    
    //MARK: - Download Browsing
    /// fetch usdz on the server and rethrieve all usdz info (not downloaded yet)
    func fetchUsdzObjects() async throws -> [UsdzObjectWrapper] {
        //guard let url = URL(string: "https://studioframeserver.herokuapp.com/usdz-objects") else { return StudioframeUrlProviderError}
        /// Choose here between local or heroku server for the request
        guard let url = urlProvider.createUsdzListRequestUrl() else { return [] }
        let urlRequest = URLRequest(url: url)
        
        let usdzObjects: [UsdzObject] = try await networkManager.fetch(urlRequest: urlRequest)
        
        /// check if we already downloaded the usdz for the view
        let allLocalFilesTitles = try studioFrameFileManager.getAllFileTitlesInDocumentsDirectory()
        
        
        let newObjects : [UsdzObjectWrapper] = usdzObjects.map { newObject in
            let isFavorited = checkFavorite(usdzobject: newObject)
            
            return UsdzObjectWrapper(
                usdzObject: newObject,
                isDownloaded: allLocalFilesTitles.description.contains(newObject.objectUrlString),
                isFavorited:  isFavorited // TODO: should handle favoriting
            )
            
        }
        return newObjects
    }
    
    /// get all the local usdz in the file
    func getLocalObjects() throws -> [UsdzObject] {
        let allLocalFilesUrls = try studioFrameFileManager.getAllFileTitlesInDocumentsDirectory()
        let usddObjects = allLocalFilesUrls.compactMap { url -> UsdzObject? in
            guard let title = url.pathComponents.last?.split(separator: ".").first?.description else {
                return nil
            }
            let object = UsdzObject(
                title: title,
                objectUrlString: url.absoluteString,
                thumbnailImageUrlString: ""
            )
            return object
        }
        
        return usddObjects
    }
    
    //MARK: - Download Management function
    ///function to stop the dowload of the usdz
    func stopDownload(usdzObject: UsdzObject) throws {
        guard let url = URL(string: "https://studioframeserver.herokuapp.com/" + usdzObject.objectUrlString) else {
            throw UsdzLibraryServiceErrorEnum.failedToStopDownload
        }
        networkManager.stopDownload(url: url)
    }
    
    /// Download the specified usdz object and store it locally
    /// - Parameter usdzObject: Object containing the url pointing to the file web location
    /// - Returns: The local URL of the downloaded USDZ object
    func downloadUsdzObject(usdzObject: UsdzObject, onDownloadProgressChanged: @escaping (Int) -> Void) async throws -> URL {
        
        // guard let url = URL(string: "http://127.0.0.1:8080/" + usdzObject.objectUrlString) else {throw UsdzLibraryServiceErrorEnum.failedToDownloadUsdzObject} (local configuration)
        guard let url = URL(string: "https://studioframeserver.herokuapp.com/" + usdzObject.objectUrlString) else {
            throw UsdzLibraryServiceErrorEnum.failedToDownloadUsdzObject
        }
        
        let urlRequest = URLRequest(url: url)
        
        let downloadedUsdzObjectData = try await networkManager.fetchFile(urlRequest: urlRequest, onDownloadProgressChanged: onDownloadProgressChanged)
        
        guard let newLocationUrl = try? studioFrameFileManager.writeData(data: downloadedUsdzObjectData, fileName: usdzObject.objectUrlString) else {
            throw UsdzLibraryServiceErrorEnum.failedToDownloadUsdzObject
        }
        
        return newLocationUrl
    }
    
    func removeDownload(usdzObject: UsdzObject) throws {
        try studioFrameFileManager.removeFileFromDocumentsDirectiory(fileName:  usdzObject.objectUrlString)
        removeFavorite(usdzObject: usdzObject)
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
    
    func clearAllDownload() throws {
        try studioFrameFileManager.deleteAllFilesExceptAirForce()
        addAirForceFavorite()
    }
    
    //MARK: - Favorite Function
    func getFavoriteObjects() -> [UsdzObject] {
        return coreDataManager.getItems()
    }
    
    func addFavorite(usdzObject: UsdzObject) {
        coreDataManager.addItem(usdz: usdzObject)
    }
    
    func removeFavorite(usdzObject: UsdzObject) {
        coreDataManager.deleteItem(with: usdzObject)
    }
    
    func deleteAllFavorite() throws {
        try coreDataManager.deleteAllItems()
    }
    
    func checkFavorite(usdzobject: UsdzObject) -> Bool{
        let favoritedUsdzObjects = getFavoriteObjects()
        
        let isFavorited = favoritedUsdzObjects.contains { favoritedUsdzObject in
            favoritedUsdzObject.title == usdzobject.title
        }
        return isFavorited
    }
    
    private func addAirForceFavorite() {
        let airForce = try? studioFrameFileManager.getFileUrl(fileName: "AirForce")
        let favoriteObject = getFavoriteObjects()
        let isFavorited = favoriteObject.contains { favoriteObject in
            favoriteObject.objectUrlString.split(separator: "/").last?.description == airForce?.pathComponents.last?.split(separator: "/").last?.description
        }
        if isFavorited == false {
            coreDataManager.addItem(usdz: UsdzObject.init(title: "AirForce", objectUrlString: "\(airForce?.description ?? "")", thumbnailImageUrlString: ""))
        }
    }
    
    func clearAllDownloadAndFavorite() throws {
        try studioFrameFileManager.deleteAllFilesExceptAirForce()
        try deleteAllFavorite()
    }
    
    //MARK: - Private let
    /// Singleton of the network manager
    private let networkManager : NetworkManagerProtocol
    private let urlProvider: StudioframeUrlProviderProtocol
    private let studioFrameFileManager = StudioFrameFileManager.shared
    private let coreDataManager = UsdzCoreDataManager.shared
    

}
