import Foundation
import SwiftUI

struct PageThreeView: View {
    
    @Binding var selectedOnboardingTag : Int
    
    var body: some View{
        VStack {
            Spacer(minLength: 225)
            Image(systemName: "text.book.closed.fill")
                .resizable()
                .frame(width: 145, height: 145)
                .foregroundColor(.orange)
            Spacer()
            Text("Download and set your favorite 3D objets !")
            Spacer()
            Button("Continue") {
                selectedOnboardingTag = 3
            }
            Spacer(minLength: 50)
        }
    }
}
