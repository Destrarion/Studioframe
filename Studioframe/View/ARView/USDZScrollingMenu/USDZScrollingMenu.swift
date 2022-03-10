//
//  ARItemMenu.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 19/01/2022.
//

import Foundation
import SwiftUI
import RealityKit

@MainActor
final class USDZScrollingMenuViewModel: ObservableObject {
    
    let usdzObjectContainers: [UsdzObjectContainer] = [
        .init(fileName: "AirForce")
    ]
    
}



@MainActor
struct USDZScrollingMenu: View {
    
    init(experience: StudioFrameExperience) {
        self.experience = experience
    }
    
    var experience: StudioFrameExperience?
    
    @StateObject var viewModel = USDZScrollingMenuViewModel()

    
    var body: some View {
        
        objectLibraryView
        
    }
    
    
    @ViewBuilder
    var objectLibraryView: some View {
        
        List(viewModel.usdzObjectContainers, id : \.id) { usdzObjectContainer in
            
            HStack {
                Button {
                    print("should add item with filename => \(usdzObjectContainer.fileName) object to arview")
                    experience!.addUsdzObject(usdzResourceName: usdzObjectContainer.fileName)
                    
                } label: {
                    ThumbnailUsdzAddButton(viewModel: usdzObjectContainer)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .frame(width: 100, alignment: .bottomTrailing)
        
    }
    
    
    
    
    
    
}
