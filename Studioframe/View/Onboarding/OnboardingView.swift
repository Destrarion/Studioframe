import Foundation
import SwiftUI

struct OnboardingView: View {
    
    @Binding var hasSeenOnboarding: Bool
    @State var selectedOnboardingTag = 0
    
    var body: some View {
        TabView(selection: $selectedOnboardingTag) {
            
            PageOne(selectedOnboardingTag: $selectedOnboardingTag)
            .tag(0)
            PageTwo(selectedOnboardingTag: $selectedOnboardingTag)
            .tag(1)
            PageThree(selectedOnboardingTag: $selectedOnboardingTag)
            .tag(2)
            PageFour(hasSeenOnboarding: $hasSeenOnboarding)
            .tag(3)
        }
        .tabViewStyle(.page)
    }
}
