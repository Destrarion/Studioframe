//
//  ContentView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 30/11/2021.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @State private var isItemsMenuOpen : Bool = false
    @State var textConsolePrint : String = ""
    
    @StateObject private var studioFrameExperience = StudioFrameExperience()

    var body: some View {
        NavigationView{
            ZStack {
                ARViewContainer(experience: studioFrameExperience)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Button("Test Add") {
                            studioFrameExperience.addUsdzObject(usdzResourceName: "AirForce")
                            textConsolePrint = studioFrameExperience.textConsolePrint
                        }
                        
                        Button("Remove") {
                            studioFrameExperience.removeSelectedEntity()
                            textConsolePrint = studioFrameExperience.textConsolePrint
                        }
                        Text(textConsolePrint)
                        
                        NavigationLink {
                            LocalLibraryListView()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 45, height: 45, alignment: .bottomLeading)
                        }
                        .padding(10)
                        .cornerRadius(100)
                        .rotationEffect(isItemsMenuOpen ? .degrees(90) : .degrees(0))
                        .animation(.easeIn(duration: 0.5), value: isItemsMenuOpen)
                        
                        Spacer()
                    }
                }
            }.onTapGesture {
                textConsolePrint = studioFrameExperience.textConsolePrint
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    init(experience: StudioFrameExperience) {
        self.experience = experience
    }
    
    var experience: StudioFrameExperience?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        experience?.arView = arView
        
        // Must have LiDAR avaible
        ///https://developer.apple.com/videos/play/wwdc2020/10612/
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
        // Load the "Box" scene from the "Experience" Reality File
        let scene = try! experience!.loadExperience()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(scene)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        Group {
//            NavigationView {
//            ContentView()
//                .previewInterfaceOrientation(.portrait)
//            }
//        }
//    }
//}
//#endif


