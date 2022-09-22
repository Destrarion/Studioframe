//
//  AirForceExperience.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 06/01/2022.
//

import Foundation
import RealityKit
import simd
import Combine
import SwiftUI


extension NSNotification.Name {
    static let shouldAddUsdzObject: NSNotification.Name = .init("shouldAddUsdzObject")
}

@available(iOS 13.0, macOS 10.15, *)
class StudioFrameExperience: NSObject, ObservableObject {
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            forName: .shouldAddUsdzObject,
            object: nil,
            queue: .main
        ) { [weak self ] notification in
            let objectUrl = notification.object as! URL
            
            self?.addUsdzObject(usdzResourceUrl: objectUrl)
            }
    }
    
    var textConsolePrint: String {
        selectedEntity?.name ?? ""
    }
    
    private static var streams = [AnyCancellable]()
    
    var arView: ARView!
    var scene: StudioFrameScene?
    @Published var selectedEntity: Entity? {
        didSet {
            if selectedEntity == nil {
                // textConsolePrint = "SET TO NIL ENTITY"
                print("SET TO NIL ENTITY")
                print()
            }
        }
    }

    /// Load the object into the Experience file into the scene "Main scene"
    func loadExperience() throws -> StudioFrameExperience.StudioFrameScene {
        let experienceURL = Bundle.main.url(forResource: "Experience", withExtension: "reality")!
        let realityFileSceneURL = experienceURL.appendingPathComponent("MainScene", isDirectory: false)
        let sceneAnchorEntity = try StudioFrameScene.loadAnchor(contentsOf: realityFileSceneURL)
        let scene = createScene(from: sceneAnchorEntity)
        self.scene = scene
        
        
       
        return scene
    }
    
    func removeSelectedEntity() {
        guard let selectedEntity = selectedEntity else {
            // textConsolePrint = "Selected entity is nil "
            print("Selected entity is nil ")
            print()
            return
        }

        selectedEntity.removeFromParent()
        self.selectedEntity = nil
    }
    
    
    
  func addUsdzObject(usdzResourceName: String) {
      var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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

                self?.arView.installGestures([.rotation, .translation, .scale], for: loadedModelEntity)
                if let gestureRecognizers = self?.arView.gestureRecognizers {
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
    
    
    func getEntityWith(name: String) -> Entity? {
        scene?.findEntity(named: name)
    }



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

        
        if let entity = arView.entity(at: location) {
            selectedEntity = entity
        }
        
        return true
    }
}

