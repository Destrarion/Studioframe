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

@available(iOS 13.0, macOS 10.15, *)
class StudioFrameExperience: ObservableObject {
    
    var textConsolePrint = ""
    
    private static var streams = [AnyCancellable]()
    
    var arView: ARView!
    var scene: StudioFrameScene?
    var selectedEntity: Entity? {
        didSet {
            if selectedEntity == nil {
                textConsolePrint = "SET TO NIL ENTITY"
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
        
        enablePlacement()
        
       
        return scene
    }
    
    func removeSelectedEntity() {
        guard let selectedEntity = selectedEntity else {
            textConsolePrint = "Selected entity is nil "
            print("Selected entity is nil ")
            print()
            return
        }

        selectedEntity.removeFromParent()
        self.selectedEntity = nil
    }
    
    
    
    func addUsdzObject(usdzResourceName: String) {
        let usdzUrl = Bundle.main.url(forResource: usdzResourceName, withExtension: ".usdz")!

        ModelEntity.loadModelAsync(contentsOf: usdzUrl)
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
                self?.scene?.addChild(loadedModelEntity)
                self?.textConsolePrint = "\(loadedModelEntity.name) created"
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
    
    #warning("Multiple confict between touch, including TapGesture but moving the screen result to a drag non recognized. Or that the touch is not selecting")
    // SOLUTIONS : - https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
    private func enablePlacement() {
        let longGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handletap(recognizer:)))
        arView.addGestureRecognizer(longGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handletap(panRecognizer:)))
        arView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func handletap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)
        
        if let entity = arView.entity(at: location) {
            selectedEntity = entity
            textConsolePrint = "\(entity.name) selected"
        }
        
        
    }
    
    @objc func handletap(panRecognizer: UIPanGestureRecognizer) {
        let location = panRecognizer.location(in: arView)
        
        if let entity = arView.entity(at: location) {
            selectedEntity = entity
        }
        
        
    }
    

    class StudioFrameScene: RealityKit.Entity, RealityKit.HasAnchoring {

    }

}

extension ARView {
  
}

