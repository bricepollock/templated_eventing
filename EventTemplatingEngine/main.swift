//
//  main.swift
//  EventTemplatingEngine
//
//  Created by Brice Pollock on 4/12/22.
//

import Foundation
import Mustache

enum TemplateType: String {
    case ios
    case android
    
    var outputDirectory: String {
        switch self {
        case .ios: return "ios"
        case .android: return "android"
        }
    }
    
    var fileExtension: String {
        switch self {
        case .ios: return ".swift"
        case .android: return ".kt"
        }
    }
}

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
            var json =  try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String: Any]
            
            // Perform json operations such as adding new template key-values
            let updatedNames = (json["cases"] as! [[String: Any]]).map { nameDictionary -> [String: Any] in
                var newDictionary = nameDictionary
                let snakeCaseName = ((nameDictionary["name"] as? String) ?? "").replacingOccurrences(of: ".", with: "_")
                let caseName = snakeCaseName.camelCased(with: "_")
                newDictionary["case_name"] = caseName
                newDictionary["case_name_caps"] = snakeCaseName.uppercased()
                return newDictionary
            }
            json["cases"] = updatedNames
            json["parameter_capitalized"] = (json["parameter"] as! String).camelCased(with:"_").capitalized
            
            // Get all templates to apply to event files
            try fileManager.contentsOfDirectory(atPath: templateFilesHome)
                .forEach { templateFile in
                    let templateFilePath = templateFilesHome + "/" + templateFile
                    let template = try Template(path: templateFilePath)
                    let rendering = try template.render(json)
                    
                    // Write template outputs to disk
                    let platform = String(templateFile.dropLast(".txt".count))
                    guard let templateType = TemplateType(rawValue: platform) else {
                        throw NSError(domain: "bad_enum", code: 101)
                    }
                    let outputFilePath = outputFilesHome + "/\(templateType.outputDirectory)/" + String(eventFile.dropLast(".json".count)) + templateType.fileExtension
                    
                    try rendering.write(toFile: outputFilePath, atomically: true, encoding: .unicode)
                }
        }
} catch {
    print("Encountered error: \(error)")
}


