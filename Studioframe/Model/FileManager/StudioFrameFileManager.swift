//
//  StudioFrameFileManager.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 21/04/2022.
//

import Foundation



final class StudioFrameFileManager {
    
    init() {
        try? saveSeed()
    }
    
    static let shared = StudioFrameFileManager()
    
    func moveFile(at originUrlPath: URL, fileName: String) throws -> URL {
        let newLocationUrl = getDocumentsDirectory().appendingPathComponent(fileName)
        try FileManager.default.copyItem(at: originUrlPath, to: newLocationUrl)
        
        return newLocationUrl
    }
    
    
    func removeFileFromDocumentsDirectiory(fileName: String) throws {
        let fileLocationUrl = getDocumentsDirectory().appendingPathComponent(fileName)
        try removeFile(at: fileLocationUrl)
    }
    
    func removeFile(at locationUrl: URL) throws {
        try FileManager.default.removeItem(at: locationUrl)
    }
    
    
    func getFileUrl(fileName: String) throws -> URL {
        let fileLocationURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return fileLocationURL
    }
    
    func getAllFileTitlesInDocumentsDirectory() throws -> [URL] {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(" get the document in documents \(fileURLs)")
            return fileURLs
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        
        return []
    }
    
    /// moving the Airforce from the Bundle.main to file
    private func saveSeed() throws {
        try moveFile(at: Bundle.main.url(forResource: "AirForce", withExtension: ".usdz")!,fileName: "AirForce.usdz")
    }
    
    
    
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
 
    func deleteAllFiles() {
        let files = try! getAllFileTitlesInDocumentsDirectory()
        files.forEach { fileUrl in
            try! removeFile(at: fileUrl)
        }
    }
}
