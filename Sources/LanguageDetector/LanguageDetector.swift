import Foundation
import Collections

public class Detector {
    var loadedLangs = [String]()
    var loadedSubsets = [ResourceManager.Subset]()

    let MIN_WORD_LENGTH = 1
    let MAX_WORD_LENGTH = 3
    let MAX_NGRAMS = 310

    public static func detect(text: String, languages: [String]) throws -> String? {
        guard !languages.isEmpty else {
            throw DetectorError.emptyLanguageList
        }
        return try Detector(langs: languages).evaluate(text: text)?.first?.0
    }
    
    private init() { }
    
    public init(langs: [String] = []) throws {
        try self.addLanguages(langs)
    }

    public func addLanguages(_ langs: [String]) throws {
        for lang in langs {
            if !self.loadedLangs.contains(lang) {
                let resource = try ResourceManager.default.getResource(name: lang)
                self.loadedLangs.append(lang)
                self.loadedSubsets.append(resource)
            }
        }
    }

    public func evaluate(text: String) throws -> [(String, Double)]? {
        guard !self.loadedLangs.isEmpty else {
            throw DetectorError.emptyLanguageList
        }
        guard text.count > 0 else {
            return nil
        }
        var scores = [(String, Double)]()
        let tokens = tokenize(text)
        for subset in loadedSubsets {
            let score = self.calculate(subset: subset, samples: sample(tokens: tokens))
            scores.append((subset.name, score))
        }
        return scores.sorted { $0.1 > $1.1 }
    }

    private func calculate(subset: ResourceManager.Subset, samples: [String]) -> Double {
        // index is accumulated at the start of the loop, so we initiate it as -1
        var index = -1
        var sum = 0
        for chunk in samples {
            index+=1
            guard let freq = subset.frequency[chunk] else {
                sum += MAX_NGRAMS
                continue
            }
            sum += abs(index - freq)
        }
        return 1.0 - (Double(sum) / Double(MAX_NGRAMS * index))
    }

    private func sample(tokens: [String]) -> [String] {
        guard tokens.count != 0 else {
            return []
        }

        var chunks = OrderedDictionary<Int, OrderedDictionary<String, Int>>()
        var ngrams = OrderedDictionary<Int, OrderedDictionary<String, Double>>() 
        for word in tokens {
            for i in MIN_WORD_LENGTH...MAX_WORD_LENGTH {
                if chunks[i] == nil {
                    chunks[i] = [:]
                }
                for j in 0..<word.count {
                    guard i + j - 1 < word.count else {
                        break
                    }
                    let part = word[(j)..<(j+i)]
                    let currentValue = chunks[i]![part] ?? 0
                    chunks[i]![part] = currentValue+1
                }
            }
        }

        for chunk in chunks {
            let sum = chunk.value.reduce(0) { $0 + $1.value }
            
            if (ngrams[chunk.key] == nil) {
                ngrams[chunk.key] = [:]
            }
            for item in chunk.value {
                ngrams[chunk.key]![item.key] = Double(item.value) / Double(sum)
            }
        }

        let merged: OrderedDictionary<String, Double> = ngrams.reduce(into: OrderedDictionary()) { pre, cur in
            for item in cur.value {
                if item.key == "_" { continue }
                pre[item.key] = item.value
            }   
        }
        let result = merged.sorted { $0.value > $1.value && $0.key > $1.key }
            .map { $0.key }

        return result.count > MAX_NGRAMS ? Array(result[0...MAX_NGRAMS]) : result
    }

    private func tokenize(_ text: String) -> [String] {
        var transformedText = text.lowercased()
        let unicodeRegex = try! Regex("[^\\p{L}\\s]")
        transformedText = transformedText
            .replacing(unicodeRegex, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // We should split the string with the following regex
        // But Negative-Look-Back is not supported on Swift :(
        // let regex = try! Regex(#"[^\p{L}]+(?<![\x27\x60\x{2019}])"#)
         return transformedText.split(separator: " ").map {"_\($0)_"}
    }
}
