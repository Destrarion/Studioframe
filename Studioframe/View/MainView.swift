
import SwiftUI
import RealityKit


struct MainView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    @StateObject private var studioFrameExperience = StudioFrameExperience()
    @State var isScrollingUSDZMenuOpen = false
    @State var isLibraryPresented = false
    
    var body: some View {
        TabView {
            ARTabView(
                studioFrameExperience: studioFrameExperience,
                isScrollingUSDZMenuOpen: $isScrollingUSDZMenuOpen
            )
            LibraryListTabView(isScrollingUSDZMenuOpen: $isScrollingUSDZMenuOpen,
                               isLibraryPresented: $isLibraryPresented)
            SettingsTabView()
        }
    }
}

