import Foundation
import RealityKit
import simd
import Combine
import ARKit


@available(iOS 13.0, macOS 10.15, *)
class StudioFrameExperience: NSObject, ObservableObject {
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            forName: .shouldAddUsdzObject,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            
            guard let objectUrl = notification.object as? URL else { return }
            self?.addUsdzObject(usdzResourceUrl: objectUrl)
        }
    }
    
    var textConsole: String {
        selectedEntity?.name ?? ""
    }
    
    
    
    var arView: ARView?
    
    var scene: StudioFrameScene?
    @Published var selectedEntity: Entity?
    
    /// Load the object into the Experience file into the scene "Main scene"
    func loadExperience() throws -> StudioFrameExperience.StudioFrameScene {
        guard let experienceURL = Bundle.main.url(forResource: "Experience", withExtension: "reality") else { throw StudioFrameExperienceError.failedToCreateURL }
        let realityFileSceneURL = experienceURL.appendingPathComponent("MainScene", isDirectory: false)
        
        let baseEntity = try ModelEntity.load(contentsOf: realityFileSceneURL)
        baseEntity.generateCollisionShapes(recursive: true)
        let sceneAnchorEntity = try StudioFrameScene.loadAnchor(contentsOf: realityFileSceneURL)
        let scene = createScene(from: sceneAnchorEntity)
        self.scene = scene
        
        scene.addChild(baseEntity)
        
        return scene
    }
    
    func removeSelectedEntity() {
        guard let selectedEntity = selectedEntity else {
            return
        }
        
        selectedEntity.removeFromParent()
        self.selectedEntity = nil
    }
    
    
    
    func addUsdzObject(usdzResourceName: String) {
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        url.appendPathComponent(usdzResourceName + ".usdz")
        addUsdzObject(usdzResourceUrl: url)
    }
    
    func addUsdzObject(usdzResourceUrl: URL) {
        ModelEntity.loadModelAsync(contentsOf: usdzResourceUrl)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] loadedModelEntity in
                loadedModelEntity.generateCollisionShapes(recursive: true)
                self?.arView?.installGestures([.rotation, .translation, .scale], for: loadedModelEntity)
                if let gestureRecognizers = self?.arView?.gestureRecognizers {
                    for gestureRecognizer in gestureRecognizers {
                        gestureRecognizer.delegate = self
                    }
                }
                loadedModelEntity.name = usdzResourceUrl.lastPathComponent.split(separator: ".").first?.description ?? ""
                self?.scene?.addChild(loadedModelEntity)
            }
            .store(in: &subscriptions)
    }
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    
    private func createScene(from anchorEntity: RealityKit.AnchorEntity) -> StudioFrameScene {
        let airForceScene = StudioFrameScene()
        airForceScene.anchoring = anchorEntity.anchoring
        return airForceScene
    }
    
    
    class StudioFrameScene: RealityKit.Entity, RealityKit.HasAnchoring {
        
    }
    
}


extension StudioFrameExperience: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: arView)
        
        if let entity = arView?.entity(at: location) {
            selectedEntity = entity
        }
        
        return true
    }
}
