import Foundation

@testable import Studioframe


final class StudioframeUrlProviderMock: StudioframeUrlProviderProtocol {
    func createUsdzDownloadRequestUrl(name: String) -> URL? {
        return nil
    }
    
    func createUsdzListRequestUrl() -> URL? {
        return nil
    }

}
