//
//  StudioframeUrlProviderMock.swift
//  StudioframeTests
//
//  Created by Fabien Dietrich on 06/10/2022.
//

import Foundation

@testable import Studioframe


final class StudioframeUrlProviderMock: StudioframeUrlProviderProtocol {
    func createUsdzListRequestUrl() -> URL? {
        return nil
    }

}
