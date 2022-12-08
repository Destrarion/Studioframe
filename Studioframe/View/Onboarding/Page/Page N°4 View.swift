//
//  Page N°4 View.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 08/12/2022.
//

import Foundation
import SwiftUI

struct PageFour: View {
    
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View{
        VStack {
            Spacer()
            Text("Open the Library for more Object !")
            Spacer()
            Button("Start") {
                hasSeenOnboarding = true
            }
            Spacer(minLength: 50)
        }
    }
}
