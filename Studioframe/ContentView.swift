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



struct LocalLibraryListView: View {
    
    let items: [String] = [
        "Black wooden Chair",
        "Stool",
        "Slate",
        "Black wooden Chaird",
        "Stoolf",
        "Slate",
        "Black wooden Chairg",
        "Stoolh",
        "Slatea"
    ]
    
    init() {
        UITableView.appearance().backgroundColor = .black
      
        UITableView.appearance().contentInset.top = -45
    }
    
    
    
    
    var body: some View {
        
        List {
//            Section {
                
                ForEach(items, id: \.self) { item in
                    HStack{
                        Image("Image_Not_Available")
                            .resizable()
                            .scaledToFit()
                        Spacer()
                        VStack {
                            Text(item)
                                .foregroundColor(.white)
                                .frame(width: 175, alignment: .topLeading)
                                .font(.body.bold())

                            Spacer()
                        }
                    }
                    .padding(.top, 10)
                }

                
                
//            } header: {
//               Text("Local Objects")
//            }
            
//            Section {
//
//            } header: {
//                Text("Online objects")
//            }

            
            .listRowSeparator(.visible)
            .listRowSeparatorTint(.white)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
        }
        .padding(.leading, -50)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Local Library")
//        .toolbar {
//            Button {
//
//            } label: {
//                Text("+")
//                    .foregroundColor(.white)
//            }
//
//        }
        
  
        
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
            LocalLibraryListView()
                .previewInterfaceOrientation(.portrait)
            }
        }
    }
}
#endif


extension UINavigationController {
    open override func viewDidLoad() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundColor = .black
        standardAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.white
        ]
        
        navigationBar.standardAppearance = standardAppearance
        
        
        
    }
}
