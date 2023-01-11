import Foundation


final class StudioFrameFileManager {
    
    init() {
        try? saveSeed()
    }
    
    static let shared = StudioFrameFileManager()
    
    func readFileData(fileName: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ".usdz") else{
            throw StudioFrameFileManagerErrorEnum.bundleFileURLError
        }
        
        return try Data(contentsOf: url)
    }
    
    func writeData(data: Data, fileName: String) throws -> URL {
        let newLocationUrl = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data.write(to: newLocationUrl)
        } catch {
            print(error.localizedDescription)
            throw StudioFrameFileManagerErrorEnum.unknownError
        }

        return newLocationUrl
    }
    
    func moveFile(at originUrlPath: URL, fileName: String) throws -> URL {
        let newLocationUrl = getDocumentsDirectory().appendingPathComponent(fileName)
        try FileManager.default.copyItem(at: originUrlPath, to: newLocationUrl)
        
        return newLocationUrl
    }
    
    func removeFileFromDocumentsDirectiory(
        fileName: String,
        shouldAppendDocumentPath: Bool = true
    ) throws {
        if shouldAppendDocumentPath {
            let fileLocationUrl = getDocumentsDirectory().appendingPathComponent(fileName)
            try removeFile(at: fileLocationUrl)
        } else {
            try removeFile(at: URL(string: fileName)!)
        }
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
    
    func deleteAllFilesExceptAirForce() throws {
        let files = try getAllFileTitlesInDocumentsDirectory()
        for fileUrl in files {
            print(fileUrl.lastPathComponent)
            guard !fileUrl.lastPathComponent.hasPrefix("AirForce") else {
                continue
            }
            try removeFile(at: fileUrl)
        }
    }
}
