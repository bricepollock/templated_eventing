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
    try fileManager.contentsOfDirectory(atPath: eventFilesHome)
        .forEach { eventFile in
            let eventFilePath = eventFilesHome + "/" + eventFile
            // Get all event files and convert them into json
            let data = try Data(contentsOf: URL(fileURLWithPath: eventFilePath))
            let json =  try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary

            // Get all templates to apply to event files
            try fileManager.contentsOfDirectory(atPath: templateFilesHome)
                .map { templateFile in templateFilesHome + "/" + templateFile }
                .forEach { templateFilePath in
                    let template = try Template(path: templateFilePath)
                    let rendering = try template.render(json)
                    print(rendering)
                    
                    // Write template outputs to disk
                    let outputFilePath = outputFilesHome + "/" + String(eventFile.dropLast(".json".count)) + ".swift"
                    print(outputFilePath)
                    try rendering.write(toFile: outputFilePath, atomically: true, encoding: .unicode)
                }
        }
} catch {
    print("Encountered error: \(error)")
}


