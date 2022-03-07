//
//  ContentView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 30/11/2021.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
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
                                Image(systemName: "text.book.closed.fill")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.orange)
                            }
                            .padding(.leading, 20)
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
                            .padding(20)
                            .cornerRadius(100)
                            .rotationEffect(isItemsMenuOpen ? .degrees(90) : .degrees(0))
                            .animation(.easeIn(duration: 0.5), value: isItemsMenuOpen)
                        }
                    }
            }
            .navigationBarHidden(true)
        }
    }
    
    
    let usdzObjectContainers: [UsdzObjectContainer] = [
        .init(fileName: "tv_retro"),
        .init(fileName: "AirForce"),
        .init(fileName: "tv_retro"),
        .init(fileName: "AirForce"),
        .init(fileName: "tv_retro"),
        .init(fileName: "tv_retro"),
        .init(fileName: "AirForce"),
        .init(fileName: "tv_retro"),
        .init(fileName: "AirForce"),
        .init(fileName: "tv_retro"),
        .init(fileName: "AirForce"),
        .init(fileName: "AirForce")
    ]
    
    @ViewBuilder
    var objectLibraryView: some View {
        
        List(usdzObjectContainers, id : \.id) { usdzObjectContainer in
            
            HStack {
                Button {
                    print("should add item with filename => \(usdzObjectContainer.fileName) object to arview")
                    studioFrameExperience.addUsdzObject(usdzResourceName: usdzObjectContainer.fileName)
                    
                } label: {
                    LocalLibraryObjectAddButton(viewModel: usdzObjectContainer)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .frame(width: 100, alignment: .bottomTrailing)
        
    }
    
}


struct LocalLibraryObjectAddButton: View {
    
    @ObservedObject var viewModel: UsdzObjectContainer
    
    var body: some View {
        ZStack {
            (viewModel.image ?? Image(systemName: "circle"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .frame(width: 50)
        .cornerRadius(100)
    }
}

@MainActor
class UsdzObjectContainer: ObservableObject, Identifiable {
    private let thumbnailGenerator = ThumbnailGenerator.shared
    
    init(fileName: String) {
        self.fileName = fileName
        
        loadThumbnailImage()
    }
    
    private func loadThumbnailImage() {
        Task {
            isLoading.toggle()
            _ = try await Task.sleep(nanoseconds: 3_000_000_000)
            self.image = await thumbnailGenerator.generateThumbnail(for: fileName, size: CGSize(width: 400, height: 400))
            isLoading.toggle()
        }
    }
    
    let id = UUID()
    let fileName: String
   
    @Published var image: Image?
    @Published var isLoading = false
    
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
        /// https://developer.apple.com/videos/play/wwdc2020/10612/
        arView.environment.sceneUnderstanding.options = []
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        arView.environment.sceneUnderstanding.options.insert(.collision)

        // Load the "Box" scene from the "Experience" Reality File
        let scene = try! experience!.loadExperience()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(scene)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
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


