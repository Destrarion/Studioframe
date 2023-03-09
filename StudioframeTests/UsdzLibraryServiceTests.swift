import XCTest

@testable import Studioframe

final class UsdzLibraryServiceTests: XCTestCase {
    
    var usdzLibraryService: UsdzLibraryService!
    
    /// Renitialise UsdzLibraryService and clear it favorite
    override func setUpWithError() throws {
        usdzLibraryService = UsdzLibraryService()
    }
    
    /// Delete all favorite
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try usdzLibraryService.clearAllDownloadAndFavorite()
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
    func test_givenNoFavorite_whenAddFavorite_thenFavoriteAdded() throws {
        try usdzLibraryService.deleteAllFavorite()
        let usdzToAdd = UsdzObject(title: "UsdzToAdd", objectUrlString: "To add", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdzToAdd)
        XCTAssertEqual(usdzLibraryService.getFavoriteObjects().first?.title, usdzToAdd.title)
    }
    
    /// Test Add Favorite if already one existed
    func test_givenOneFavoriteUsdz_whenAddFavoriteUsdz_thenUsdzFavoriteAddedAtRow2() {
        /// First favorite usdz added in usdzlibraryservice init
        let usdz = UsdzObject(title: "usdz", objectUrlString: "1.2.3", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdz)
        let favorite = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favorite.count, 2)
        XCTAssertEqual(favorite[1].title,usdz.title)
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
    
    func test_givenAirForceFavorite_whenClearAllDownload_thenOnlyOneAirforceRemain() {
        var favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favoriteUsdz.count, 1)
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
    func test_givenUsdzLibrary_whenFetchAllLocalUsdz_thenReturnLocalUsdz() throws {
        let localObjects = try usdzLibraryService.getLocalObjects()
        XCTAssertEqual(localObjects.count, 1)
    }
    
    /// Test Check if already downloaded
    func test_givenAirForceUsdzFile_whenCheckingIfAlreadyDownloaded_thenReturnTrue() throws {
        let localObjects = try usdzLibraryService.getLocalObjects()
        let firstLocalObject = try XCTUnwrap(localObjects.first)
        XCTAssertTrue(usdzLibraryService.getIsDownload(usdzObject: firstLocalObject))
    }
    
    /// Test Usdz we fake it with the mock taking AirForce from Bundle and give him the AirForce instead of download
    func test_givenNoFileUsdz_whenFetchFile_thenGetAirForceFile() async throws {
        
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
    
   
    func test_givenIsDownloading_whenStopDownload_thenDownloadStopped() throws {
        let usdz = UsdzObject(title: "Fakeusdz", objectUrlString: "fakedownload", thumbnailImageUrlString: "notTestingThat")
        
        try usdzLibraryService.stopDownload(usdzObject: usdz)
    }
    
    
    func test_given_when_then() {
        
    }
}
