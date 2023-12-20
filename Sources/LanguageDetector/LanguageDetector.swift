// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


class Detector {
    var loadedLangs = [String]()
    var loadedSubsets = [ResourceManager.Subset]()

    static func detect(text: String, langs: [String]) -> [(String, Double)]? {
        Detector(langs: langs).evaluate(text: text)
    }

    init(langs: [String] = []) {
        self.addLang(langs)
    }

    func addLang(_ langs: [String]) {
        for lang in langs {
            do {
                if !self.loadedLangs.contains(lang) {
                    let resource = try ResourceManager.default.getResource(name: lang)
                    self.loadedLangs.append(lang)
                    self.loadedSubsets.append(resource)
                }
            } catch {
                print("Error loading language resource subset: \(lang)", error)
            }            
        }
    }

    func evaluate(text: String) -> [(String, Double)]? {
        guard text.count > 0 else {
            return nil
        }
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        var scores = [(String, Double)]()
        for subset in loadedSubsets {
            let score = self.calculate(subset: subset, chunks: chunk(text: trimmedText))
            scores.append((subset.name, score))
        }
        return scores.sorted(by: { $0.1 > $1.1 })
    }

    private func calculate(subset: ResourceManager.Subset, chunks: [String]) -> Double {
        let freqSum = chunks.reduce(0) { $0 + (subset.frequency[$1] ?? 0) }
        let nWordsSum = subset.nWords.reduce(0) { $0 + $1 }
        return Double(freqSum) / Double(nWordsSum)
    }

    private func chunk(text: String) -> [String] {
        var chunks = [String]()
        
        for i in 0..<3 {
            for j in 0..<text.count {
                if (text.count > j + i) {
                    chunks.append(text[(j)...(j+i)])
                }
            }
        }

        return chunks
    }
}
