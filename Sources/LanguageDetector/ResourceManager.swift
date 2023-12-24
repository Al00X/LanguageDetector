import Foundation


class ResourceManager {
    static let `default` = ResourceManager()
    
    var loadedResources = [String: Subset]()

    struct Subset: Codable {
        var frequency: [String: Int]
        var name: String
        
        enum CodingKeys: String, CodingKey {
            case frequency
            case name
        }
    }
    
    func getResource(name: String) throws -> Subset {
        guard loadedResources[name] == nil else {
            return loadedResources[name]!
        }
        guard let configURL = Bundle.module.url(forResource: name, withExtension: "") else {
            throw DetectorError.resourceNotFound(language: name)
        }
        let data = try Data(contentsOf: configURL)
        let subset = try JSONDecoder().decode(Subset.self, from: data)
        loadedResources[name] = subset
        return subset
    }
    
}
