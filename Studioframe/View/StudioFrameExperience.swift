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
class StudioFrameExperience {

    private static var streams = [AnyCancellable]()
    
    var arView: ARView!
    var scene: StudioFrameScene?

    /// Load the object into the Experience file into the scene "Main scene"
    func loadExperience() throws -> StudioFrameExperience.StudioFrameScene {
        let experienceURL = Bundle.main.url(forResource: "Experience", withExtension: "reality")!
        let realityFileSceneURL = experienceURL.appendingPathComponent("MainScene", isDirectory: false)
        let sceneAnchorEntity = try StudioFrameScene.loadAnchor(contentsOf: realityFileSceneURL)
        let scene = createScene(from: sceneAnchorEntity)
        
        self.scene = scene
        return scene
    }
    
    
    
    func addUsdzObject(usdzResourceName: String) {
        let usdzUrl = Bundle.main.url(forResource: usdzResourceName, withExtension: ".usdz")!

        ModelEntity.loadModelAsync(contentsOf: usdzUrl)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let failure):
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] loadedModelEntity in
                loadedModelEntity.generateCollisionShapes(recursive: true)
                self?.arView.installGestures([.rotation, .translation, .scale], for: loadedModelEntity)
                self?.scene?.addChild(loadedModelEntity)
            }
            .store(in: &subscriptions)

        
        
  
        
        
        
       
        //print("it is named 📑:", scene?.children.first)
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




//
//    public static func loadBoxAsync(completion: @escaping (Swift.Result<AirForceExperience.BoxScene, Swift.Error>) -> Void) {
//        guard let realityFileURL = Foundation.Bundle(for: AirForceExperience.BoxScene.self).url(forResource: "Experience", withExtension: "reality") else {
//            completion(.failure(AirForceExperience.LoadRealityFileError.fileNotFound("Experience.reality")))
//            return
//        }
//
//        var cancellable: Combine.AnyCancellable?
//        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
//        let loadRequest = AirForceExperience.BoxScene.loadAnchorAsync(contentsOf: realityFileSceneURL)
//        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
//            if case let .failure(error) = loadCompletion {
//                completion(.failure(error))
//            }
//            streams.removeAll { $0 === cancellable }
//        }, receiveValue: { entity in
//            completion(.success(AirForceExperience.createBox(from: entity)))
//        })
//        cancellable?.store(in: &streams)
//    }
