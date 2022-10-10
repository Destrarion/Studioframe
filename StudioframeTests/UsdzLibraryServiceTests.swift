//
//  UsdzLibraryServiceTests.swift
//  StudioframeTests
//
//  Created by Fabien Dietrich on 27/09/2022.
//

import XCTest

@testable import Studioframe

final class UsdzLibraryServiceTests: XCTestCase {
    
    
    var usdzLibraryService: UsdzLibraryService!
    
    override func setUpWithError() throws {
        usdzLibraryService = UsdzLibraryService()
        usdzLibraryService.deleteAllFavorite()
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        usdzLibraryService.deleteAllFavorite()
    }

    func test_givenUrlProviderFail_whenFetchUsdzObjects_thenObjectsIsEmpty() async throws {
        let urlProviderMock = StudioframeUrlProviderMock()
        usdzLibraryService = UsdzLibraryService(urlProvider: urlProviderMock)
        
        let objects = try await usdzLibraryService.fetchUsdzObjects()
        
        XCTAssertTrue(objects.isEmpty)
    }
    
    func test_givenSuccessNetwork_whenFetchUsdzObjects_thenObjectsIsNotEmpty() async throws {
        let networkManagerMock = MockNetworkManagerSuccess()
        usdzLibraryService = UsdzLibraryService(networkManager: networkManagerMock)
        
        let objects = try await usdzLibraryService.fetchUsdzObjects()
        
        XCTAssertFalse(objects.isEmpty)
    }
    

    // MARK: - Favorite test
    
    func test_givenUsdzLibraryService_whenUsdzLibraryServiceInit_thenAddAirForceInFavorite() {
        usdzLibraryService.addFavorite(usdzObject: UsdzObject(title: "AirForce", objectUrlString: "should be done at init", thumbnailImageUrlString: "but Xcode randomize test when i unchecked randomise anyway"))
        let favorite = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favorite.first!.title, "AirForce")
    }
    
    func test_givenNoFavorite_whenAddFavorite_thenFavoriteAdded() {
        let usdzToAdd = UsdzObject(title: "UsdzToAdd", objectUrlString: "To add", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdzToAdd)
        XCTAssertEqual(usdzLibraryService.getFavoriteObjects().first?.title, usdzToAdd.title)
    }
    
    func test_givenNoFavoriteUsdz_whenAddFavoriteUsdz_thenUsdzFavoriteAdded() {
        let usdz = UsdzObject(title: "usdz", objectUrlString: "1.2.3", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdz)
        let favorite = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favorite.count, 1)
        XCTAssertEqual(favorite[0].title,usdz.title)
        print("🔺",usdzLibraryService.getFavoriteObjects())
        usdzLibraryService.deleteAllFavorite()
    }
    
    func test_givenAirForceFavorite_whenRemoveFavoriteAirForce_thenNoFavoriteRemain() {
        let airForce = UsdzObject(title: "AirForce", objectUrlString: "3.2.1", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: airForce)
        var favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        usdzLibraryService.removeFavorite(usdzObject: favoriteUsdz.first!)
        favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        print("⚠️",favoriteUsdz)
        XCTAssertEqual(favoriteUsdz.count, 0)
    }
    
    
    func test_givenUsdzFavorited_whenCheckFavorite_thenReturnTrue() {
        let usdzCheckFavorite = UsdzObject(title: "usdzCheckFavoriteTrue", objectUrlString: "Favorite should be true", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdzCheckFavorite)
        XCTAssertTrue(usdzLibraryService.checkFavorite(usdzobject: usdzCheckFavorite))
    }
    
    func test_givenZeroUsdzFavorited_whenCheckFavorite_thenReturnFalse() {
        let usdzCheckFavorite = UsdzObject(title: "usdzCheckFavoriteFalse", objectUrlString: "Favorite should be false", thumbnailImageUrlString: "none")
        XCTAssertFalse(usdzLibraryService.checkFavorite(usdzobject: usdzCheckFavorite))
    }
    
    
    //MARK: - USDZ File test
    
    func test_givenUsdzLibrary_whenFetchAllLocalUsdz_thenReturnLocalUsdz() {
        guard let localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        print("🚧", localUsdz)
        XCTAssertEqual(localUsdz.count, 1)
    }
    
    func test_givenAirForceUsdzFile_whenCheckingIfAlreadyDownloaded_thenReturnTrue() {
        guard let localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        XCTAssertTrue(usdzLibraryService.getIsDownload(usdzObject: localUsdz.first!))
        
    }
    
    
}
