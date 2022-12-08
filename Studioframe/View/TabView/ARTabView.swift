import SwiftUI


struct ARTabView: View {
    
    @ObservedObject var studioFrameExperience: StudioFrameExperience
    @Binding var isScrollingUSDZMenuOpen: Bool
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .trailing) {
                ARViewContainer(experience: studioFrameExperience)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        if isScrollingUSDZMenuOpen {
                            USDZScrollingMenu(experience: studioFrameExperience)
                                .frame(width: 80, alignment: .bottomTrailing)
                        }
                    }
                    HStack {
                        
                        ARViewInterface(experience: studioFrameExperience, isScrollingUSDZMenuOpen: $isScrollingUSDZMenuOpen)
                        Button {
                            isScrollingUSDZMenuOpen.toggle()
                            
                        } label: {
                            Image(systemName: isScrollingUSDZMenuOpen ? "plus.circle" : "plus.circle.fill")
                                .resizable()
                                .frame(width: 45, height: 45, alignment: .bottomLeading)
                            
                        }
                        .padding(20)
                        .cornerRadius(100)
                        .rotationEffect(isScrollingUSDZMenuOpen ? .degrees(90) : .degrees(0))
                        .animation(.easeIn(duration: 0.5), value: isScrollingUSDZMenuOpen)
                    }
                }
            }
            .navigationBarHidden(true)
            .onDisappear {
                isScrollingUSDZMenuOpen = false
            }
        }
        .tabItem {
            Image(systemName: "camera.fill")
            Text("AR")
        }
        .navigationViewStyle(.stack)
    }
}
