//
//  SettingsView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 15/09/2022.
//

import Foundation
import SwiftUI


struct SettingsView: View{
    
    var body : some View {
        VStack{
            Text("Settings")
            
            List{
                Link (destination: URL(string: "https://twitter.com/FabienDietrich")!){
                        Text("Twitter")
                }
                Link (destination: URL(string: "https://github.com/Destrarion/Studioframe")!){
                        Text("GitHub")
                }
            }
        }
    }
}
