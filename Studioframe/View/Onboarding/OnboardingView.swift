import Foundation
import SwiftUI

struct OnboardingView: View {
    
    @Binding var hasSeenOnboarding: Bool
    @State var selectedOnboardingTag = 0
    
    var body: some View {
        TabView(selection: $selectedOnboardingTag) {
            
            PageOneView(selectedOnboardingTag: $selectedOnboardingTag)
            .tag(0)
            PageTwoView(selectedOnboardingTag: $selectedOnboardingTag)
            .tag(1)
            PageThreeView(selectedOnboardingTag: $selectedOnboardingTag)
            .tag(2)
            PageFour(hasSeenOnboarding: $hasSeenOnboarding)
            .tag(3)
        }
        .tabViewStyle(.page)
    }
}
