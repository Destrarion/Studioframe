//
//  StudioFrameFileManager.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 21/04/2022.
//

import Foundation



final class StudioFrameFileManager {
    
    static let shared = StudioFrameFileManager()
    
    func moveFile(at originUrlPath: URL, fileName: String) throws -> URL {
        let newLocationUrl = getDocumentsDirectory().appendingPathComponent(fileName)
        try FileManager.default.copyItem(at: originUrlPath, to: newLocationUrl)
        return newLocationUrl
    }
    
    
    func removeFile(at locationUrl: URL) throws {
        try FileManager.default.removeItem(at: locationUrl)
    }
    
    
    func getAllFileTitlesInDocumentsDirectory() throws -> [String] {
        return [
            "tv_retro"
        ]
    }
    
    
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
 
}
