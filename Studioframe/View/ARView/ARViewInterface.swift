//
//  ARViewInterface.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import SwiftUI

struct ARViewInterface: View {
    
    init(experience: StudioFrameExperience) {
        self.experience = experience
    }
    
    var experience: StudioFrameExperience?
    
    var body: some View {
        HStack {
            
            NavigationLink {
                LibraryListView()
            } label: {
                Image(systemName: "text.book.closed.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.orange)
            }
            .padding(.leading, 20)
            Spacer()
            
            Button("Remove") {
                experience!.removeSelectedEntity()
            }
            Text(experience!.textConsolePrint)
            
            Spacer()

        }
    }
}
