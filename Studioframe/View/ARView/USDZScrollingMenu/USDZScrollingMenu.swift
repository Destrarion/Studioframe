import Foundation
import SwiftUI
import RealityKit


struct USDZScrollingMenu: View {
    
    init(experience: StudioFrameExperience) {
        self.experience = experience
        self._viewModel = StateObject(wrappedValue: USDZScrollingMenuViewModel())
        
    }
    
    @ObservedObject var experience: StudioFrameExperience
    @StateObject var viewModel: USDZScrollingMenuViewModel
    
    var body: some View {
        objectLibraryView
    }
    
    
    @ViewBuilder
    var objectLibraryView: some View {
        
        if !viewModel.usdzObjectContainers.isEmpty {
            List(viewModel.usdzObjectContainers, id : \.id) { usdzObjectContainer in
                HStack {
                    Button {
                        experience.addUsdzObject(usdzResourceName: usdzObjectContainer.fileName)
                        
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
            .hideBackgroundOnList()
        } else {
            EmptyView()
        }
        
    }
}

extension View {
    @ViewBuilder
    func hideBackgroundOnList() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollContentBackground(.hidden)
        } else {
            self
        }
    }
}
