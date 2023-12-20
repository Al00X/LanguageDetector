// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class ResourceManager {
    static var loadedResources: [String: Subset] = [:]

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
        if loadedResources[name] != nil {
            return loadedResources[name]!;
        }
        let configURL = Bundle.module.url(forResource: name, withExtension: "")
        let data = try Data(contentsOf: configURL!)
        let json = try JSONDecoder().decode(Subset.self, from: data)
        loadedResources[name] = json;
        return json
    }
    
}

class Detector {
    var loadedLangs: [String] = [];
    var loadedSubsets: [ResourceManager.Subset] = [];

    static func detect(text: String, langs: [String]) -> [(String, Double)]? {
        let instance = Detector(langs: langs);
        return instance.evaluate(text: text);
    }

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

    func evaluate(text: String) -> [(String, Double)]? {
        if text.count == 0 {
            return nil;
        }
        var scores: [(String, Double)] = [];
        for lang in loadedSubsets {
            let score = self.calculate(subset: lang, chunks: self.chunk(text: text))
            scores.append((lang.name, score));
        }
        return scores.sorted(by: { $0.1 > $1.1 });
    }

    private func calculate(subset: ResourceManager.Subset, chunks: [String]) -> Double {
        var freqSum = 0.0;
        for chunk in chunks {
            freqSum += Double(subset.frequency[chunk] ?? 0);
        }
        let nWordsSum = subset.nWords.reduce(0, { a, b in a + b})
        return freqSum / Double(nWordsSum);
    }

    private func chunk(text: String) -> [String] {
        var chunks: [String] = [];
        
        for i in 0..<3 {
            for j in 0..<text.count {
                if (text.count > j + i) {
                    chunks.append(text[(j)...(j+i)])
                }
            }
        }

        return chunks;
    }
}
