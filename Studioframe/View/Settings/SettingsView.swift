//
//  SettingsView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 15/09/2022.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    
    @StateObject var settingViewModel = SettingsViewModel()
    @State var showClearAllFavoritesAlert = false
    @State var showClearAllDownloadedFilesAlert = false
    
    var body : some View {
        VStack{
            Text("Settings")
            
            
            List{
                
                Section {
                    Link (destination: URL(string: "https://twitter.com/FabienDietrich")!){
                        Text("Twitter")
                            .foregroundColor(.teal)
                    }
                    Link (destination: URL(string: "https://github.com/Destrarion/Studioframe")!){
                        Text("GitHub")
                    }
                }
                
                
                Section {
                    Button {
                        
                        showClearAllFavoritesAlert.toggle()
                    } label: {
                        Text("Clear all favorite ")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showClearAllFavoritesAlert) {
                        Alert(title: Text("Are you sure to clear all favorite ?"),
                              message: Text("All favorite will be gone after this"),
                              primaryButton: .destructive(Text("Favorite must be purged")) {
                            settingViewModel.clearAllFavorite()
                            
                        },
                              secondaryButton: .cancel())
                    }
                    
                    Button {
                        showClearAllDownloadedFilesAlert.toggle()
                    } label: {
                        Text("Clear all downloaded files ")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showClearAllDownloadedFilesAlert) {
                        Alert(title: Text("Are you sure to clear all Files ?"),
                              message: Text("All files and favorited downloaded files will be purged in the process"),
                              primaryButton: .destructive(Text("Files must be purged")) {
                            settingViewModel.clearAllDownload()
                            settingViewModel.clearAllFavorite()
                            
                        },
                              secondaryButton: .cancel())
                    }
                }
                
                
            }
          
            
            
        }
        .listStyle(.grouped)
    }
}
