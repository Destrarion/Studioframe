//
//  NetworkManager.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 24/02/2022.
//

import Foundation


class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    
    func fetch<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: self)
        
        print((response as? HTTPURLResponse)?.statusCode ?? "-1")
        
        let jsonDecoder = JSONDecoder()
        
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        
        return decodedData
        
    }
    
    func fetchFile(urlRequest: URLRequest) async throws -> URL {
        let (downloadedFileLocationUrl, response) = try await URLSession.shared.download(for: urlRequest, delegate: self)
        
        print("⚠️⚠️⚠️⚠️⚠️")
        print((response as? HTTPURLResponse)?.statusCode ?? "-1")
        
    
        return downloadedFileLocationUrl
    }
    
    
    
    func fetchData(urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: self)
        
        print((response as? HTTPURLResponse)?.statusCode ?? "-1")
        
        return data
        
    }

}

//extension NetworkManager: URLSessionTaskDelegate {
//
//
//}

extension NetworkManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("✅✅FINISHED DOWNLOAD AT URL")
        print(location.absoluteString)
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("❌❌❌ERROR DOWNLOAD")
        print(error ?? "error occured")
    }
    
    
    
}
