import Foundation
import Mixpanel

/// Model for MixPanel 
final class TrackingService {
    static let shared = TrackingService()
    
    private let mixpanelInstance: MixpanelInstance
    
    init() {
        Mixpanel.initialize(token: "d4d00a48e60230a09f1d45159daa6ea9", trackAutomaticEvents: true)
        self.mixpanelInstance = Mixpanel.mainInstance()
    }
    
    
    func track(event: TrackingEvent) {
        mixpanelInstance.track(
            event: event.title,
            properties: event.properties
        )
    }
    
    
    
}
