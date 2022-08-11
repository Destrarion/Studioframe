import Foundation

@MainActor
final class USDZScrollingMenuViewModel: ObservableObject {
    var usdzLibraryService = UsdzLibraryService.shared
    
   init() throws {

       
       usdzObjectContainers = try usdzLibraryService.getLocalObjects().map {
           UsdzObjectContainer(fileName: $0.title, fileUrl: $0.objectUrlString)
       }
       

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
