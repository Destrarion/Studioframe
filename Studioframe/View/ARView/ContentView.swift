//
//  ContentView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 30/11/2021.
//

import SwiftUI
import RealityKit


struct MainView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        }
    
    @StateObject private var studioFrameExperience = StudioFrameExperience()
    @State private var isScrollingUSDZMenuOpen: Bool = false
    @State var isLibraryPresented = false
    
    var body: some View {
        TabView {
            NavigationView{
                ZStack(alignment: .trailing) {
                    ARViewContainer(experience: studioFrameExperience)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        HStack{
                            Spacer()
                            if isScrollingUSDZMenuOpen {
                                try! USDZScrollingMenu(experience: studioFrameExperience)
                                    .frame(width: 80, alignment: .bottomTrailing)
                            }
                        }
                        HStack {
                            
                            ARViewInterface(experience: studioFrameExperience, isScrollingUSDZMenuOpen: $isScrollingUSDZMenuOpen)
                            Button {
                                self.isScrollingUSDZMenuOpen.toggle()
                                
                            } label: {
                                Image(systemName: self.isScrollingUSDZMenuOpen ? "plus.circle" : "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 45, height: 45, alignment: .bottomLeading)
                                
                            }
                            .padding(20)
                            .cornerRadius(100)
                            .rotationEffect(isScrollingUSDZMenuOpen ? .degrees(90) : .degrees(0))
                            .animation(.easeIn(duration: 0.5), value: isScrollingUSDZMenuOpen)
                        }
                    }
                }
                .navigationBarHidden(true)
                .onDisappear(perform: {
                    isScrollingUSDZMenuOpen = false
                })
            }
      
            .tabItem {
                Image(systemName: "camera.fill")
                Text("AR")
            }
            .navigationViewStyle(.stack)
            
      
            NavigationView() {
                LibraryListView()
            }
            .tabItem {
                Button {
                    isScrollingUSDZMenuOpen = false
                    isLibraryPresented = true
                } label: {
                    Image(systemName: "text.book.closed.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
                Text("Library")
            }
            
            
            NavigationView() {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
            
            
        }
    }
}

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





