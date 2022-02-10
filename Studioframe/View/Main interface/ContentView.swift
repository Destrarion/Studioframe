//
//  ContentView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 30/11/2021.
//

import SwiftUI
import RealityKit
import QuickLookThumbnailing

struct ContentView: View {
    
    
    
    @State private var isItemsMenuOpen : Bool = false
    
    @StateObject private var studioFrameExperience = StudioFrameExperience()
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .trailing) {
                ARViewContainer(experience: studioFrameExperience)
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        HStack{
                        Spacer()
                        if isItemsMenuOpen {
                            objectLibraryView
                                .frame(width: 80, alignment: .bottomTrailing)
                        }
                        }
                        HStack {
                            
                            NavigationLink {
                                LocalLibraryListView()
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button("Remove") {
                                studioFrameExperience.removeSelectedEntity()
                            }
                            Text(studioFrameExperience.textConsolePrint)
                            
                            Spacer()
                            
                            Button {
                                self.isItemsMenuOpen.toggle()

                            } label: {
                                Image(systemName: self.isItemsMenuOpen ? "plus.circle" : "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 45, height: 45, alignment: .bottomLeading)
                                
                            }
                            .padding(10)
                            .cornerRadius(100)
                            .rotationEffect(isItemsMenuOpen ? .degrees(90) : .degrees(0))
                            .animation(.easeIn(duration: 0.5), value: isItemsMenuOpen)
                        }
                    }
            }
            .navigationBarHidden(true)
        }
    }
    
    
    
    
    @State var usdzObjectContainers: [UsdzObjectContainer] = [
        .init(fileName: "tv_retro", image: Image(systemName: "square.and.arrow.up")),
        .init(fileName: "AirForce", image: Image(systemName: "circle")),
        .init(fileName: "tv_retro", image: Image(systemName: "square.and.arrow.up")),
        .init(fileName: "AirForce", image: Image(systemName: "circle")),
        .init(fileName: "tv_retro", image: Image(systemName: "square.and.arrow.up")),
        .init(fileName: "AirForce", image: Image(systemName: "circle"))
        
    ]
    
    @ObservedObject var thumbnailGenerator = ThumbnailGenerator()
    
    
    @ViewBuilder
    var objectLibraryView: some View {
        
        
        List(usdzObjectContainers, id : \.id) { usdzObjectContainer in
            
            HStack {
                Button {
                    print("should add item with filename => \(usdzObjectContainer.fileName) object to arview")
                    studioFrameExperience.addUsdzObject(usdzResourceName: usdzObjectContainer.fileName)
                    thumbnailGenerator.generateThumbnail(for: usdzObjectContainer.fileName, size: CGSize(width: 400, height: 400))
                    
                } label: {
                    imageButton()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .cornerRadius(100)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .frame(width: 100, alignment: .bottomTrailing)
        
        
    }
    
    func imageButton() -> Image {
        
        if thumbnailGenerator.thumbnailImage != nil{
           return thumbnailGenerator.thumbnailImage!
        }else {
            return Image(systemName: "circle")
        }
    }
    
}

struct UsdzObjectContainer : Identifiable {
    let id = UUID()
    var fileName: String
    let image: Image
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


struct ARIEntityMenu : View {
    
    
    var body: some View {
        HStack{
            Text("A")
            Text("B")
            Text("C")
        }
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ContentView()
                    .previewInterfaceOrientation(.portrait)
            }
        }
    }
}
#endif


