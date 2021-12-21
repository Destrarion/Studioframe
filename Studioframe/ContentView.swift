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
    
    
    var body: some View {
        
        
        NavigationView{
            
            ZStack {
                
                
                ARViewContainer().edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        
                        
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
            }
            
        }
        
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ARItemsMenu : View {
    
    let width : CGFloat
    let menuOpened : Bool
    
    
    var body: some View {
        HStack{
            
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


