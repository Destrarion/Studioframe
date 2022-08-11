//
//  ARViewInterface.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import SwiftUI

struct ARViewInterface: View {
    
    @ObservedObject var experience: StudioFrameExperience
    @Binding var isScrollingUSDZMenuOpen: Bool
    
    @State var isLibraryPresented = false
    
    var body: some View {
        HStack {
          
            
            Button {
                isScrollingUSDZMenuOpen = false
                isLibraryPresented = true
            } label: {
                Image(systemName: "text.book.closed.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.orange)
            }
            .padding(.leading, 20)

            
            NavigationLink(destination: LibraryListView(), isActive: $isLibraryPresented) {
                EmptyView()
            }
            
        
           
            Spacer()
            
            Button("Remove") {
                experience.removeSelectedEntity()
            }
            Text(experience.textConsolePrint)
            
            Spacer()

        }
    }
}
