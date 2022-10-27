import XCTest

@testable import Studioframe

final class UsdzLibraryServiceTests: XCTestCase {
    
    var usdzLibraryService: UsdzLibraryService!
    
    /// Renitialise UsdzLibraryService and clear it favorite
    override func setUpWithError() throws {
        usdzLibraryService = UsdzLibraryService()
        usdzLibraryService.deleteAllFavorite()
    }
    
    /// Delete all favorite
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        usdzLibraryService.deleteAllFavorite()
    }
    
    /// Test of the URL Provider (Fail) that should result to a Empty Object
    func test_givenUrlProviderFail_whenFetchUsdzObjects_thenObjectsIsEmpty() async throws {
        let urlProviderMock = StudioframeUrlProviderMock()
        usdzLibraryService = UsdzLibraryService(urlProvider: urlProviderMock)
        
        let objects = try await usdzLibraryService.fetchUsdzObjects()
        
        XCTAssertTrue(objects.isEmpty)
    }
    
    /// Test Network Fetch that succeed to a fully Object
    func test_givenSuccessNetwork_whenFetchUsdzObjects_thenObjectsIsNotEmpty() async throws {
        let networkManagerMock = MockNetworkManagerSuccess()
        usdzLibraryService = UsdzLibraryService(networkManager: networkManagerMock)
        
        let objects = try await usdzLibraryService.fetchUsdzObjects()
        
        XCTAssertFalse(objects.isEmpty)
    }
    
    // MARK: - Favorite test
    
    /// Test at init if AirForce is favorited
    func test_givenUsdzLibraryService_whenUsdzLibraryServiceInit_thenAddAirForceInFavorite() {
        usdzLibraryService.addFavorite(usdzObject: UsdzObject(title: "AirForce", objectUrlString: "should be done at init", thumbnailImageUrlString: "but Xcode randomize test when i unchecked randomise anyway"))
        let favorite = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favorite.first!.title, "AirForce")
    }
    
    /// Test Add Favorite
    func test_givenNoFavorite_whenAddFavorite_thenFavoriteAdded() {
        let usdzToAdd = UsdzObject(title: "UsdzToAdd", objectUrlString: "To add", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdzToAdd)
        XCTAssertEqual(usdzLibraryService.getFavoriteObjects().first?.title, usdzToAdd.title)
    }
    
    /// Test Add Favorite if already one existed
    func test_givenOneFavoriteUsdz_whenAddFavoriteUsdz_thenUsdzFavoriteAddedAtRow2() {
        usdzLibraryService.addFavorite(usdzObject: UsdzObject.init(title: "AirForce", objectUrlString: "", thumbnailImageUrlString: ""))
        let usdz = UsdzObject(title: "usdz", objectUrlString: "1.2.3", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdz)
        let favorite = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favorite.count, 2)
        XCTAssertEqual(favorite[1].title,usdz.title)
        usdzLibraryService.deleteAllFavorite()
    }
    
    /// Test Removing AirForce
    func test_givenAirForceFavorite_whenRemoveFavoriteAirForce_thenNoFavoriteRemain() {
        let airForce = UsdzObject(title: "AirForce", objectUrlString: "3.2.1", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: airForce)
        var favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        usdzLibraryService.removeFavorite(usdzObject: favoriteUsdz.first!)
        favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favoriteUsdz.count, 0)
    }
    
    /// Test Checking Favorite ( True )
    func test_givenUsdzFavorited_whenCheckFavorite_thenReturnTrue() {
        let usdzCheckFavorite = UsdzObject(title: "usdzCheckFavoriteTrue", objectUrlString: "Favorite should be true", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdzCheckFavorite)
        XCTAssertTrue(usdzLibraryService.checkFavorite(usdzobject: usdzCheckFavorite))
    }
    
    /// Test Checking Favorite ( False )
    func test_givenZeroUsdzFavorited_whenCheckFavorite_thenReturnFalse() {
        let usdzCheckFavorite = UsdzObject(title: "usdzCheckFavoriteFalse", objectUrlString: "Favorite should be false", thumbnailImageUrlString: "none")
        XCTAssertFalse(usdzLibraryService.checkFavorite(usdzobject: usdzCheckFavorite))
    }
    
    
    //MARK: - USDZ File test
    
    /// Test Get Local Object ( return 1)
    func test_givenUsdzLibrary_whenFetchAllLocalUsdz_thenReturnLocalUsdz() {
        guard let localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        XCTAssertEqual(localUsdz.count, 1)
    }
    
    /// Test Check if already downloaded
    func test_givenAirForceUsdzFile_whenCheckingIfAlreadyDownloaded_thenReturnTrue() {
        guard let localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        XCTAssertTrue(usdzLibraryService.getIsDownload(usdzObject: localUsdz.first!))
    }
    
    /// Test check if usdz is not downloaded
    func test_givenAirForceUsdzFile_whenCheckingIfAlreadyDownloaded_thenReturnFalse() {
        guard var localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        usdzLibraryService.remove(usdzObject: localUsdz.removeFirst())
        XCTAssertFalse(usdzLibraryService.getIsDownload(usdzObject: UsdzObject(title: "", objectUrlString: "", thumbnailImageUrlString: "")))
    }
    
    /// Test removing downloaded usdz
    func test_givenUsdzLibrary_whenRemoveAirForce_thenAirForceRemoved (){
        var localUsdz = try? usdzLibraryService.getLocalObjects()
        usdzLibraryService.remove(usdzObject: localUsdz!.removeFirst())
        XCTAssertFalse(usdzLibraryService.getIsDownload(usdzObject: UsdzObject.init(title: "Airforce", objectUrlString: "", thumbnailImageUrlString: "")))
    }
    
    /// Test Usdz we fake it with the mock taking AirForce from Bundle and give him the AirForce instead of download
    func test_givenNoFileUsdz_whenFetchFile_thenGetAirForceFile() async throws {
        StudioFrameFileManager.shared.deleteAllFiles()
        
        let networkManagerMock = MockNetworkManagerSuccess()
        
        usdzLibraryService = UsdzLibraryService(networkManager: networkManagerMock)
        
        let exempleUsdz = UsdzObject(
            title: "AirForce",
            objectUrlString: "AirForce.usdz",
            thumbnailImageUrlString: ""
        )
        
        _ = try await usdzLibraryService.downloadUsdzObject(
            usdzObject: exempleUsdz,
            onDownloadProgressChanged: { _ in }
        )
        
        let localUsdzObjects = try usdzLibraryService.getLocalObjects()
        
        let containsExampleUsdz = localUsdzObjects.contains { localUsdzObject in
            localUsdzObject.title == exempleUsdz.title
        }
        XCTAssertTrue(containsExampleUsdz)
    }
   
#warning("no clue how to test stopDownload")
    func test_givenFakeDownloadUrl_whenStopDownload_thenDownloadStopped() {
        let usdz = UsdzObject(title: "Fakeusdz", objectUrlString: "fakedownload", thumbnailImageUrlString: "notTestingThat")
        usdzLibraryService.stopDownload(usdzObject: usdz)
    }
    
    
}
