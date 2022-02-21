//
//  NavigationBarConfigurator.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 23/12/2021.
//

import UIKit


final class NavigationBarConfigurator {
    static let shared = NavigationBarConfigurator()
    
    
    func setupCustomNavigationBar() {
        
        let appeareance = UINavigationBarAppearance()
        appeareance.configureWithOpaqueBackground()
        appeareance.backgroundColor = .clear
        
        //appeareance.largeTitleTextAttributes = [
            //.font : UIFont.systemFont(ofSize: 18),
            //.foregroundColor : UIColor.white
        //]
        
        appeareance.titleTextAttributes = [
            //.font : UIFont.systemFont(ofSize: 6),
            .foregroundColor : UIColor.white
        ]
        
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().standardAppearance = appeareance
        UINavigationBar.appearance().scrollEdgeAppearance = appeareance
        UINavigationBar.appearance().compactAppearance = appeareance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appeareance

    
        
    }
}
