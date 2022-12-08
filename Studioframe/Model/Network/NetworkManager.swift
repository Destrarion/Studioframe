//
//  NetworkManager.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 24/02/2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(urlRequest: URLRequest) async throws -> T
    func fetchFile(urlRequest: URLRequest, onDownloadProgressChanged: @escaping (Int) -> Void) async throws -> Data
    func stopDownload(url: URL)
    
}

class NetworkManager: NSObject, NetworkManagerProtocol {
    
    //MARK: - Internal - Static let
    static let shared = NetworkManager()
    
    //MARK: - Internal - Function
    func stopDownload(url: URL) {
        cleanDownload(url: url)
    }
    
    func fetch<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)
        
        let jsonDecoder = JSONDecoder()
        
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        
        return decodedData
        
    }
    
    func fetchFile(
        urlRequest: URLRequest,
        onDownloadProgressChanged: @escaping (Int) -> Void
    ) async throws -> Data {
        
        //onDownloadProgressChanged(0)
        try await triggerFileDownload(urlRequest: urlRequest, onDownloadProgressChanged: onDownloadProgressChanged)
        
    }
    
    //MARK: - Private - Function
    private func triggerFileDownload(
        urlRequest: URLRequest,
        onDownloadProgressChanged: @escaping (Int) -> Void
    ) async throws -> Data {
        
        //let (url, _) = try await session.download(for: urlRequest, delegate: self)
        
        let (asyncBytes, urlResponse) = try await session.bytes(for: urlRequest)
        
        let length = Int(urlResponse.expectedContentLength)
        var data = Data()
        data.reserveCapacity(length)
        
        var lastProgressPercentage = 0
        
        for try await byte in asyncBytes {
            let progress = Int((Double(data.count) / Double(length)) * 100.0)
            data.append(byte)
            
            if lastProgressPercentage != progress {
                print("🍅 DOWNLOAD PROGRESS \(progress)%")
                onDownloadProgressChanged(progress)
                lastProgressPercentage = progress
            }
        }
        
        return data
    }

    private func cleanDownload(url: URL) {
        let key = url.absoluteString
        onDownloadProgressChangedContainer.removeValue(forKey: key)
        session.invalidateAndCancel()
        session = URLSession(configuration: .default)
    }
    //MARK: - Private - Variables
    private lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(
            configuration: sessionConfiguration,
            delegate: nil,
            delegateQueue: .main
        )
        
        return session
    }()
    
    private var onDownloadProgressChangedContainer: [String: ((Int) -> Void)] = [:]

    
}
