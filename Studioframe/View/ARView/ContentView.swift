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
    
    var body: some View {
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
                        
                        ARViewInterface(experience: studioFrameExperience)
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
    }
    
    
}



