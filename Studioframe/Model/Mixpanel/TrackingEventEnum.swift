//
//  TrackingEventEnum.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 08/12/2022.
//

import Foundation
import Mixpanel

enum TrackingEventEnum {
    case addFavorite
    case downloadUsdz
    case removeUsdz
    case stopDownloadUsdz
    
    
    var title: String {
        switch self {
        case .addFavorite:
            return "Add Favorite"
        case .downloadUsdz:
            return "Download USDZ"
        case .removeUsdz:
            return "Removed USDZ"
        case .stopDownloadUsdz:
            return "Stopped downloading Usdz"
        }
    }
    
    var properties: [String: any MixpanelType] {
        switch self {
        case .addFavorite:
            return [:]
        case .downloadUsdz:
            return [:]
        case .removeUsdz:
            return [:]
        case .stopDownloadUsdz:
            return [:]
        }
    }
}
