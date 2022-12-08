import Foundation

enum ConfigurationTypeEnum {
    case local
    case heroku
    
    private var scheme: String {
        switch self {
        case .local:
            return "http"
        case .heroku:
            return "https"
        }
    }
    
    private var port: Int? {
        switch self {
        case .local:
            return 8080
        case .heroku:
            return nil
        }
    }
    
    private var host: String {
        switch self {
        case .local:
            return "127.0.0.1"
        case .heroku:
            return "studioframeserver.herokuapp.com"
        }
    }
    
    
    var schemeWithHostAndPort: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = port
        
        return urlComponents.url!
    }
}
