import Foundation

@MainActor
final class USDZScrollingMenuViewModel: ObservableObject {
    var usdzLibraryService = UsdzLibraryService.shared
    
   init() throws {
       //let usdzObjects = try await usdzLibraryService.fetchUsdzObjects()
       //fetch
       
       usdzObjectContainers = try usdzLibraryService.getLocalObjectsTest().map {
           UsdzObjectContainer(fileName: $0.title)
       }
       
       // usdzObjectContainers = [
       // .init(
       //     fileName: try usdzLibraryService.fetchAllLocalObjects().objectUrlString
       // )
       //]
   }
    
    lazy var usdzObjectContainers: [UsdzObjectContainer] = []
    
    
    
    
    
    
    
    
    // MARK: TEST Seed
  //
  //  func saveDefaultUsdz() {
  //      let url = Bundle.main.url(forResource: "AirForce", withExtension: "usdz")!
  //      fileManager.moveFile(at: url, fileName: "AirForce")
  //  }
  //
    
   //private let fileManager = StudioFrameFileManager.shared
    
    
    
}
