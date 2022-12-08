//
//  Page N°1.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 08/12/2022.
//

import Foundation
import SwiftUI

struct PageOne: View {
    
    @Binding var selectedOnboardingTag : Int
    
    var body: some View{
        VStack {
            Spacer(minLength: 225)
            Text("Welcome to StudioFrame!")
                .font(.system(size: 40))
            Spacer()
            Text("An Augmented Reality app for your house !")
            Spacer(minLength: 200)
            Button("Continue") {
                selectedOnboardingTag = 1
            }
            Spacer(minLength: 50)
        }
    }
}
