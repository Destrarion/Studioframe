//
//  ARItemMenu.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 19/01/2022.
//

import Foundation
import SwiftUI
import RealityKit


struct USDZScrollingMenu: View {
    
    init(experience: StudioFrameExperience) throws {
        self.experience = experience
        self._viewModel = StateObject(wrappedValue: try! USDZScrollingMenuViewModel())
        
        
    }
    
    var experience: StudioFrameExperience?
    
    @StateObject var viewModel: USDZScrollingMenuViewModel
    
    var body: some View {
        
        objectLibraryView
        
    }
    
    
    @ViewBuilder
    var objectLibraryView: some View {
        
        let list = List(viewModel.usdzObjectContainers, id : \.id) { usdzObjectContainer in
            
            HStack {
                Button {
                    print("should add item with filename => \(usdzObjectContainer.fileName) object to arview")
                    //NotificationCenter.default.post(name: .shouldAddUsdzObject, object: viewModel.usdzObjectContainers.first?.fileName)
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
        if #available(iOS 16.0, *) {
            list.scrollContentBackground(.hidden)
                } else {
                    list.background(.clear)
                }
        
    }
    
    
    
    
    
    
}
