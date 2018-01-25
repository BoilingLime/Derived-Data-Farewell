//
//  FileManagerService.swift
//  Derived Data Farewell
//
//  Created by Longueville Xavier on 25/01/2018.
//  Copyright © 2018 Plover. All rights reserved.
//

import Foundation

// *********************************************************************
// MARK: - FileManagerService

class FileManagerService: NSObject {

    class func setCustomderivedData(_ path: String) {
        UserDefaults.standard.set(path, forKey: "path")
    }

    class func derivedDataPath() -> URL {
        if let customPathString = UserDefaults.standard.string(forKey: "path"), let customPath = URL(string: customPathString) {
            return customPath
        }

        return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Developer/Xcode/DerivedData", isDirectory: true)
    }

    class func contents(of folder: URL) -> [URL] {
        let fileManager = FileManager.default

        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
            let urls = contents.flatMap { return folder.appendingPathComponent($0, isDirectory: true) }

            return urls
        } catch {
            return []
        }
    }

    class func removeContent(of path: URL, trash: Bool = true) -> Bool {
        let fileManager = FileManager.default

        if trash {
            do {
                try fileManager.trashItem(at: path, resultingItemURL: nil)
                return true
            } catch {
                return false
            }
        } else {
            do {
                try fileManager.removeItem(at: path)
                return true
            } catch {
                return false
            }
        }
    }
}
