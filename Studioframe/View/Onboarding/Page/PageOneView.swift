import Foundation
import SwiftUI

struct PageOneView: View {
    
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
