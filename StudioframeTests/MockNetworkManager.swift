//
//  MockNetworkManager.swift
//  StudioframeTests
//
//  Created by Fabien Dietrich on 06/10/2022.
//

@testable import Studioframe
import Foundation

final class MockNetworkManagerSuccess: NetworkManagerProtocol {
    
    
    //guard let url = Bundle(for: MockNetworkManagerSuccess.self).url(forResource: "JsonResponse", withExtension: ".json"),
    //           let data = try? Data(contentsOf: url) else {
    //         return completion(nil)
    //     }
    
    func fetch<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
        let usdzObjects: [UsdzObject] = [
            .init(title: "AirForce", objectUrlString: "https://www.testurl.com/airforce", thumbnailImageUrlString: "https://www.testurl.com/airforce/img"),
            .init(title: "Tv_retro", objectUrlString: "https://www.testurl.com/tv-retro", thumbnailImageUrlString: "https://www.testurl.com/tv_retro/img"),
        ]
        return usdzObjects as! T
    }
    
    func fetchFile(urlRequest: URLRequest, onDownloadProgressChanged: @escaping (Int) -> Void, completionHandler: @escaping (URL) -> Void)  {
        var usdzservice = UsdzLibraryService.shared
        let object = usdzservice.getFavoriteObjects()
        completionHandler(URL(string: object.first!.objectUrlString)!)
    }
    
    func fetchData(urlRequest: URLRequest) async throws -> Data {
        let data = Data()
        return data
    }
    
    func stopDownload(url: URL) {
        let key = url.absoluteString
//        downloadTaskContainer[key]?.cancel()
//        cleanDownload(url: url)
    }

}

//final class MockNetworkManagerFailure: NetworkManagerProtocol {
//    func fetch<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
//        let usdzDowloaded = false
//        return usdzDowloaded as! T
//    }
//
//    func fetchFile(urlRequest: URLRequest, onDownloadProgressChanged: @escaping (Int) -> Void, completionHandler: @escaping (URL) -> Void)  {
//        let fileDowloaded = false
//        guard let error = URL(string: "wrong") else {}
//        completionHandler(error)
//    }
//
//    func fetchData(urlRequest: URLRequest) async throws -> Data {
//        let dataDowloaded = false
//        return fileDowloaded
//    }
//
//    func stopDownload(url: URL) {
//        return nil
//    }
//
//}
