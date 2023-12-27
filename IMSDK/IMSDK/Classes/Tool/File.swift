//
//  File.swift
//  ReplayDemo
//
//  Created by FSKJ on 2021/6/4.
//

import Foundation

public final class File {
    public static func remove(files: [String]) throws {
        let fileManager = FileManager.default
        try files.forEach { (file) in
            do {
                if fileManager.fileExists(atPath: file) {
                    try FileManager.default.removeItem(atPath: file)
                }
            } catch let error as NSError {
                throw error
            }
        }
    }
    
    public static func move(atPath: String, toPath: String) throws {
        let fileManager = FileManager.default
        try fileManager.moveItem(atPath: atPath, toPath: toPath)
    }

    public static func getSize(ofFiles files: [String]) throws -> UInt64 {
        let fileManager = FileManager.default
        return try files.reduce(into: 0, { (filesSize, file) in
            do {
                filesSize += (try fileManager.attributesOfItem(atPath: file)[.size] as? UInt64) ?? 0
            } catch let error as NSError {
                throw error
            }
        })
    }

    public static func isExist(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    public static func hardlink(atPath source: String, toPath destination: String) throws {
        do {
            try FileManager.default.linkItem(atPath: source, toPath: destination)
        } catch let error as NSError {
            throw error
        }
    }

    public static func createDirectory(atPath path: String) throws {
        if File.isExist(atPath: path)  {return}
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            throw error
        }
    }
}
