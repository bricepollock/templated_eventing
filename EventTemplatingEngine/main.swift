//
//  main.swift
//  EventTemplatingEngine
//
//  Created by Brice Pollock on 4/12/22.
//

import Foundation
import Mustache

// CHANGE THIS VALUE TO WHERE YOU CLONED REPO
let homePathComponents = "/src/tmp/templated_eventing"
// --

let fileManager = FileManager.default
let homeDir = fileManager.homeDirectoryForCurrentUser

let homeDirectory = homeDir.relativePath + homePathComponents
let eventFilesHome = homeDirectory + "/events"
let templateFilesHome = homeDirectory + "/templates"
let outputFilesHome = homeDirectory + "/output"

do {
    // Get all event files and convert them into json
    let eventFiles = try fileManager.contentsOfDirectory(atPath: eventFilesHome)
    let eventFilePaths = eventFiles.map { eventFilesHome + "/" + $0}
    for path in eventFilePaths {
        print("Found \(path)")
    }
    
    let jsonFiles: [Any] = try eventFilePaths.compactMap {
        let data = try Data(contentsOf: URL(fileURLWithPath: $0))        
        return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary
    }
    let testFile = eventFiles.first!
    let testJSON = jsonFiles.first!
    print(testJSON)
    
    // Get all templates to apply to event files
    let templateFilesPaths = try fileManager.contentsOfDirectory(atPath: templateFilesHome).map { templateFilesHome + "/" + $0}
    print(templateFilesPaths)
    let swiftTemplatePath = templateFilesPaths.first!
    print(swiftTemplatePath)
    let template = try Template(path: swiftTemplatePath)
    let rendering = try template.render(testJSON)
    print(rendering)
    
    // Write template outputs to disk
    let outputFilePath = outputFilesHome + "/" + String(testFile.dropLast(".json".count)) + ".swift"
    print(outputFilePath)
    try rendering.write(toFile: outputFilePath, atomically: true, encoding: .unicode)
    
} catch {
    print("Encountered error: \(error)")
}


