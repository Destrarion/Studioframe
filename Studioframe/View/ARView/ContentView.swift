import SwiftUI

struct ContentView: View {
    
    @State private var hasSeenOnboarding = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if hasSeenOnboarding {
            MainView()
        } else {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
    
    
}





