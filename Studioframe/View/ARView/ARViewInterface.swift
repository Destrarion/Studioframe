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
                experience.removeSelectedEntity()
            } label: {
                Image(systemName: "trash.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 20)
            .opacity(experience.selectedEntity != nil ? 1.0 : 0.0)

            Spacer()
            
            Text(experience.textConsolePrint)
            
            Spacer()

        }
    }
}
