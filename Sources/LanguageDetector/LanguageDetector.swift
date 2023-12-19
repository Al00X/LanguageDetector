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
        let data = try Data(contentsOf: configURL!)
        let json = try JSONDecoder().decode(Subset.self, from: data)
        print("count1: \(json.frequency.count)")
        print("count2: \(json.nWords.count)")
        print("name: \(json.name)")
        return json
    }
    
}

class Detector {
    var loadedLangs: [String] = [];
    var loadedSubsets: [ResourceManager.Subset] = [];

    init(langs: [String]?) {
        self.addLang(langs: langs ?? []);
    }

    func addLang(langs: [String]) {
        for lang in langs {
            do {
                let resource = try ResourceManager.getResource(name: lang);
                self.loadedLangs.append(lang);
                self.loadedSubsets.append(resource);
            } catch let error {
                print("Error loading language resource subset: \(lang)", error);
            }            
        }
    }
}
