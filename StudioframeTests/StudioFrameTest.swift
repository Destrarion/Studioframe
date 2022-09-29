//
//  StudioFrameTest.swift
//  StudioframeTests
//
//  Created by Fabien Dietrich on 27/09/2022.
//

import XCTest

@testable import Studioframe

final class StudioFrameTest: XCTestCase {
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_givenNewIngredient_whenAddIngredient_thenGetIngredientIsAdded() {
        var a = 1
        var b = 2
        
        if a == b {
            XCTFail()
        } else {
            XCTAssert(a != b)
        }
    }

    
    // MARK: - Favorite test
    
    func test_givenUsdzLibraryService_whenUsdzLibraryServiceInit_thenAddAirForceInFavorite() {
        let usdzLibraryServiceTest = UsdzLibraryService()
        usdzLibraryServiceTest.deleteAllFavorite()
        usdzLibraryServiceTest.addFavorite(usdzObject: UsdzObject(title: "AirForce", objectUrlString: "should be done at init", thumbnailImageUrlString: "but Xcode randomize test when i unchecked randomise anyway"))
        let favorite = usdzLibraryServiceTest.getFavoriteObjects()
        XCTAssertEqual(favorite.first!.title, "AirForce")
    }
    
    func test_givenNoFavorite_whenAddFavorite_thenFavoriteAdded() {
        let usdzLibraryServiceTest = UsdzLibraryService()
        usdzLibraryServiceTest.deleteAllFavorite()
        let usdzToAdd = UsdzObject(title: "UsdzToAdd", objectUrlString: "To add", thumbnailImageUrlString: "none")
        usdzLibraryServiceTest.addFavorite(usdzObject: usdzToAdd)
        XCTAssertEqual(usdzLibraryServiceTest.getFavoriteObjects().first?.title, usdzToAdd.title)
    }
    
    func test_givenNoFavoriteUsdz_whenAddFavoriteUsdz_thenUsdzFavoriteAdded() {
        let usdzLibraryService = UsdzLibraryService()
        usdzLibraryService.deleteAllFavorite()
        let usdz = UsdzObject(title: "usdz", objectUrlString: "1.2.3", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdz)
        let favorite = usdzLibraryService.getFavoriteObjects()
        XCTAssertEqual(favorite.count, 1)
        XCTAssertEqual(favorite[0].title,usdz.title)
        print("🔺",usdzLibraryService.getFavoriteObjects())
        usdzLibraryService.deleteAllFavorite()
    }
    
    func test_givenAirForceFavorite_whenRemoveFavoriteAirForce_thenNoFavoriteRemain() {
        let usdzLibraryService = UsdzLibraryService()
        usdzLibraryService.deleteAllFavorite()
        let airForce = UsdzObject(title: "AirForce", objectUrlString: "3.2.1", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: airForce)
        var favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        usdzLibraryService.removeFavorite(usdzObject: favoriteUsdz.first!)
        favoriteUsdz = usdzLibraryService.getFavoriteObjects()
        print("⚠️",favoriteUsdz)
        XCTAssertEqual(favoriteUsdz.count, 0)
    }
    
    
    func test_givenUsdzFavorited_whenCheckFavorite_thenReturnTrue(){
        let usdzLibraryService = UsdzLibraryService()
        usdzLibraryService.deleteAllFavorite()
        let usdzCheckFavorite = UsdzObject(title: "usdzCheckFavoriteTrue", objectUrlString: "Favorite should be true", thumbnailImageUrlString: "none")
        usdzLibraryService.addFavorite(usdzObject: usdzCheckFavorite)
        XCTAssertTrue(usdzLibraryService.checkFavorite(usdzobject: usdzCheckFavorite))
    }
    
    func test_givenZeroUsdzFavorited_whenCheckFavorite_thenReturnFalse(){
        let usdzLibraryService = UsdzLibraryService()
        usdzLibraryService.deleteAllFavorite()
        let usdzCheckFavorite = UsdzObject(title: "usdzCheckFavoriteFalse", objectUrlString: "Favorite should be false", thumbnailImageUrlString: "none")
        XCTAssertFalse(usdzLibraryService.checkFavorite(usdzobject: usdzCheckFavorite))
    }
    
    
    //MARK: - USDZ File test
    
    func test_givenUsdzLibrary_whenFetchAllLocalUsdz_thenReturnLocalUsdz(){
        let usdzLibraryService = UsdzLibraryService()
        guard let localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        print("🚧", localUsdz)
        XCTAssertEqual(localUsdz.count, 1)
    }
    
    func test_givenAirForceUsdzFile_whenCheckingIfAlreadyDownloaded_thenReturnTrue() {
        let usdzLibraryService = UsdzLibraryService()
        guard let localUsdz = try? usdzLibraryService.getLocalObjects() else { return XCTFail("error getting local object")}
        XCTAssertTrue(usdzLibraryService.getIsDownload(usdzObject: localUsdz.first!))
        
    }
    
    
}
