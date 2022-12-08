import Foundation


final class ConfigurationService {
    static let shared = ConfigurationService()
    private init() { }
    
    var configurationType: ConfigurationTypeEnum {
#if Local
        return .local
#elseif Heroku
        return .heroku
#else
        return .local
#endif
    }
}
