//
//  Page N°2 View.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 08/12/2022.
//

import Foundation
import SwiftUI

struct PageTwo: View {
    
    @Binding var selectedOnboardingTag : Int
    
    var body: some View{
        VStack {
            Spacer(minLength: 225)
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 200, height: 150)
                .foregroundColor(.gray)
            Spacer()
            Text("Set 3D model in your room !")
            Spacer()
            Button("Continue") {
                selectedOnboardingTag = 2
            }
            Spacer(minLength: 50)
        }
    }
}
