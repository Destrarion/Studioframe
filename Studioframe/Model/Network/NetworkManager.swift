//
//  NetworkManager.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 24/02/2022.
//

import Foundation


class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    
    
    private lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(
            configuration: sessionConfiguration,
            delegate: self,
            delegateQueue: .main
        )
        
        return session
    }()
    
    
    func fetch<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest, delegate: self)
        
        print((response as? HTTPURLResponse)?.statusCode ?? "-1")
        
        let jsonDecoder = JSONDecoder()
        
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        
        return decodedData
        
    }
    
    func fetchFile(
        urlRequest: URLRequest,
        onDownloadProgressChanged: @escaping (Int) -> Void,
        completionHandler: @escaping (URL) -> Void
    ) {
        
        onDownloadProgressChanged(0)
        
#if local
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.triggerFileDownload(urlRequest: urlRequest, onDownloadProgressChanged: onDownloadProgressChanged, completionHandler: completionHandler)
        }
        
        
        
        // TODO: Handle configurations
         #elseif Heroku
        self.triggerFileDownload(urlRequest: urlRequest, onDownloadProgressChanged: onDownloadProgressChanged, completionHandler: completionHandler)
        //
        
        
        // let (downloadedFileLocationUrl, response) = try await session.download(for: urlRequest, delegate: self)
        
        #endif
        
        
        print("⚠️⚠️⚠️⚠️⚠️")
        //print((response as? HTTPURLResponse)?.statusCode ?? "-1")
        
        
    }
    
    private func triggerFileDownload(
        urlRequest: URLRequest,
        onDownloadProgressChanged: @escaping (Int) -> Void,
        completionHandler: @escaping (URL) -> Void
    ) {
        self.onDownloadProgressChanged = onDownloadProgressChanged
        
        let downloadTask = session.downloadTask(with: urlRequest)
        downloadTask.resume()
        
        downloadTaskCompletionHandler = completionHandler
        
    }
    
    
    
    func fetchData(urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest, delegate: self)
        
        print((response as? HTTPURLResponse)?.statusCode ?? "-1")
        
        return data
        
    }
    
    
    private var onDownloadProgressChanged: ((Int) -> Void)?
    
    private var downloadTaskCompletionHandler: ((URL) -> Void)?
    
}

extension NetworkManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("❌didBecomeInvalidWithError DOWNLOAD")
        print(error ?? "ERROR IS NIL")
    }
}

extension NetworkManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("✅✅FINISHED DOWNLOAD AT URL")
        print(location.absoluteString)
        
        downloadTaskCompletionHandler?(location)
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print( error ?? "ERROR IS NIL")
    }
    
    
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        
        let downloadCompletionPercentage = Int((Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100.0)
        print("🍅 \(downloadCompletionPercentage)%")
        
        onDownloadProgressChanged?(downloadCompletionPercentage)
        
    }
    
    
}
