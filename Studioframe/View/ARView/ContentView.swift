//
//  ContentView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 30/11/2021.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State private var isScrollingUSDZMenuOpen: Bool = false
    
    @StateObject private var studioFrameExperience = StudioFrameExperience()
    
    @State private var hasSeenOnboarding = false
    @State private var selectedOnboardingTag = 0
    
    var body: some View {
        if hasSeenOnboarding {
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
                }
                .tabItem {
                    Text("AR")
                }
                
                NavigationView {
                    Text("Une liste avec les options / réglages / imprint / text juridique, très simple")
                }
                .tabItem {
                    Text("Settings")
                }
                
                
            }
        } else {
            TabView(selection: $selectedOnboardingTag) {
                VStack {
                    Text("Onboarding step 1")
                    Button("Start") {
                        selectedOnboardingTag = 1
                    }
                }
                .tag(0)
                VStack {
                    Text("Onboarding step 2")
                    Button("Start") {
                        hasSeenOnboarding = true
                    }
                }
                .tag(1)
                
            }
            .tabViewStyle(.page)
            
        }
    }
    
    
}



