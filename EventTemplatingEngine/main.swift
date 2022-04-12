//
//  main.swift
//  EventTemplatingEngine
//
//  Created by Brice Pollock on 4/12/22.
//

import Foundation
import Mustache

let fileManager = FileManager.default
let documentDir = fileManager.urls(for: .userDirectory, in: .allDomainsMask).first!
let homeDir = fileManager.homeDirectoryForCurrentUser
print(homeDir)

let homePathComponents = "/src/tmp/templated_eventing"
let homeDirectory = homeDir.relativePath + homePathComponents
let eventFiles = homeDirectory + "/events"
let templateFiles = homeDirectory + "/templates"
print(eventFiles)

do {
    let eventFilePaths = try fileManager.contentsOfDirectory(atPath: eventFiles).map { eventFiles + "/" + $0}
    for path in eventFilePaths {
        print("Found \(path)")
    }
    
    let jsonFiles: [Any] = try eventFilePaths.compactMap {
        let data = try Data(contentsOf: URL(fileURLWithPath: $0))        
        return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary
    }
    let testJSON = jsonFiles.first!
    
    let templateFilesPaths = try fileManager.contentsOfDirectory(atPath: templateFiles).map { templateFiles + "/" + $0}
    print(templateFilesPaths)
    let swiftTemplatePath = templateFilesPaths.first!
    let template = try Template(path: swiftTemplatePath)
    let rendering = try template.render(testJSON)
    print(rendering)
    
} catch {
    print("Encountered error: \(error)")
    // failed to read directory – bad permissions, perhaps?
}


