//
//  InitialSetupConfigurator.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 23/12/2021.
//

import Foundation


class InitialSetupConfigurator {
    static let shared = InitialSetupConfigurator()
    
    
    func setup() {
        NavigationBarConfigurator.shared.setupCustomNavigationBar()
    }
}
