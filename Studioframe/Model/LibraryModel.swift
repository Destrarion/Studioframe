//
//  Main.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 07/03/2022.
//

import Foundation

@MainActor
final class Library: ObservableObject {
    
    private let networkManager = NetworkManager.shared
    
    func fetchObjects() {
        Task {
            let url = URL(string: "http://127.0.0.1:8080/usdz-objects")!
            let urlRequest = URLRequest(url: url)
            
            let usdzObjects: [UsdzObject] = try await networkManager.fetch(urlRequest: urlRequest)
            
            self.localLibraryObjectViewModels = usdzObjects.map {
                LocalLibraryObjectViewModel(
                    usdzObject: $0,
                    onSelect: { [weak self] usdzObject in self?.onSelectItem(usdzObject: usdzObject)},
                    onRemove: { [weak self] usdzObject in self?.onRemoveItem(usdzObject: usdzObject) },
                    onFavorite: { [weak self] usdzObject in self?.onFavoriteItem(usdzObject: usdzObject) }
                )
            }
        }
    }
    
    @Published var localLibraryObjectViewModels: [LocalLibraryObjectViewModel] = []
    
    
    func onSelectItem(usdzObject: UsdzObject) {
        Task {
            print("Item selected with name: \(usdzObject.title)")
            
            let url = URL(string: "http://127.0.0.1:8080/" + usdzObject.objectUrlString)!
            let urlRequest = URLRequest(url: url)
            
            let usdzObjectLocalFileUrl: URL = try await networkManager.fetchFile(urlRequest: urlRequest)
//            let usdzObjecctData: Data = try await networkManager.fetchData(urlRequest: urlRequest)
            
            print(usdzObjectLocalFileUrl.absoluteString)
            
            let newLocationUrl = getDocumentsDirectory().appendingPathComponent(usdzObject.objectUrlString)
            
            print(newLocationUrl.absoluteString)
            
//            do {
//                try usdzObjecctData.write(to: newLocationUrl)
//            } catch {
//                print("FAILED TO WRITE")
//                print(error)
//                return
//            }
            
//
            do {
                try FileManager.default.copyItem(at: usdzObjectLocalFileUrl, to: newLocationUrl)
                //try FileManager.default.copyItem(atPath: usdzObjectLocalFileUrl.absoluteString, toPath: newLocationUrl.absoluteString)

            } catch {
                print("FAILED TO COPY USDZ FILE")
                print(error)
                return
            }
            NotificationCenter.default.post(name: .shouldAddUsdzObject, object: newLocationUrl)
            
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func onRemoveItem(usdzObject: UsdzObject) {
        print("Item removed with name: \(usdzObject.title)")
    }
    
    func onFavoriteItem(usdzObject: UsdzObject) {
        print("Item favorited with name: \(usdzObject.title)")
    }
    
    
}
struct UsdzObject: Decodable {
    let title: String
    let objectUrlString: String
}


