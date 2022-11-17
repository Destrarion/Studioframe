import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    init(experience: StudioFrameExperience) {
        self.experience = experience
    }
    
    @ObservedObject var experience: StudioFrameExperience
    
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        experience.arView = arView
        
        // Must have LiDAR avaible
        /// https://developer.apple.com/videos/play/wwdc2020/10612/
        arView.environment.sceneUnderstanding.options = []
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        arView.environment.sceneUnderstanding.options.insert(.collision)

        // Load the "Box" scene from the "Experience" Reality File
        let scene = try! experience.loadExperience()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(scene)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
