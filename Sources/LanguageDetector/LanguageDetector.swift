// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class ResourceManager {
    
    struct Subset: Codable {
        var frequency: [String: Int]
        var name: String
        var nWords: [Int]
        
        enum CodingKeys: String, CodingKey {
            case frequency = "freq"
            case name
            case nWords = "n_words"
        }
    }
    
    
    static func getResource(name: String) throws -> Subset {
        let configURL = Bundle.module.url(forResource: name, withExtension: "")
        let json = try Data(contentsOf: configURL!)
        let data = try JSONDecoder().decode(Subset.self, from: json)
        print("count1: \(data.frequency.count)")
        print("count2: \(data.nWords.count)")
        print("name: \(data.name)")
        return data
    }
    
}

