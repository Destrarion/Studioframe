//
//  FileManager.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 06/01/2022.
//

import Foundation

final class ARObjectFileManager {
    
    func getDocumentsDirectoryPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    func saveObject() -> URL? {
        return nil
    }
    
    
    
    func getObject() -> Data? {
        return nil
    }
}
