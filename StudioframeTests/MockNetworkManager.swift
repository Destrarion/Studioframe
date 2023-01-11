@testable import Studioframe
import Foundation

final class MockNetworkManagerSuccess: NetworkManagerProtocol {
    
    
    func fetch<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
        let usdzObjects: [UsdzObject] = [
            .init(title: "AirForce", objectUrlString: "https://www.testurl.com/airforce", thumbnailImageUrlString: "https://www.testurl.com/airforce/img"),
            .init(title: "Tv_retro", objectUrlString: "https://www.testurl.com/tv-retro", thumbnailImageUrlString: "https://www.testurl.com/tv_retro/img"),
        ]
        return usdzObjects as! T
    }
    
    func fetchFile(urlRequest: URLRequest, onDownloadProgressChanged: @escaping (Int) -> Void) async throws -> Data {
        let studioFrameFileManager = StudioFrameFileManager.shared
        return try studioFrameFileManager.readFileData(fileName: "AirForce")
    }
    
    func fetchData(urlRequest: URLRequest) async throws -> Data {
        let data = Data()
        return data
    }
    
    func stopDownload(url: URL) {
        _ = "https://googletakeyourdata.com"
    }
    
}

final class MockNetworkManagerFailure: NetworkManagerProtocol {
    func getIsTaskOngoing() async -> Bool {
        false
    }
    
    func fetchFile(urlRequest: URLRequest, onDownloadProgressChanged: @escaping (Int) -> Void) async throws -> Data {
        let data = Data()
        return data
    }
    
    func stopDownload(url: URL) {
        guard URL(string: "badurl.com") != nil else { return }
        
    }
    
    
    func fetch<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
    let usdzObjects: [UsdzObject] = []
    return usdzObjects as! T
}

}
