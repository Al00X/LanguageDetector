import Foundation


class Detector {
    var loadedLangs = [String]()
    var loadedSubsets = [ResourceManager.Subset]()

    let MIN_WORD_LENGTH = 1;
    let MAX_WORD_LENGTH = 3;
    let MAX_NGRAMS = 310;

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
        // guard text.count > 0 else {
        //     return nil
        // }
        // var scores = [(String, Double)]()
        // for subset in loadedSubsets {
        //     let score = self.calculate(subset: subset, chunks: chunk(text: text))
        //     scores.append((subset.name, score))
        // }
        // return scores.sorted(by: { $0.1 > $1.1 })
        return [];
    }

    private func calculate(subset: ResourceManager.Subset, chunks: [String]) -> Double {
        let freqSum = chunks.reduce(0) { $0 + (subset.frequency[$1] ?? 0) }
        // let nWordsSum = subset.nWords.reduce(0) { $0 + $1 }
        // return Double(freqSum) / Double(nWordsSum)
        return 0.0;
    }

    public func chunk(text: String) -> [String] {
        let tokens = tokenize(text);

        guard tokens.count != 0 else {
            return [];
        }

        var chunks = [Int: [String: Int]]();
        var ngrams = [Int: [String: Double]](); 
        for word in tokens {
            for i in MIN_WORD_LENGTH...MAX_WORD_LENGTH {
                if chunks[i] == nil {
                    chunks[i] = [:];
                }
                for j in 0..<word.count {
                    guard i + j - 1 < word.count else {
                        break;
                    }
                    let part = word[(j)..<(j+i)];
                    let currentValue = chunks[i]![part] ?? 0;
                    chunks[i]![part] = currentValue+1;
                }
            }
        }

        for chunk in chunks {
            let sum = chunk.value.reduce(0) { $0 + $1.value }
            
            if (ngrams[chunk.key] == nil) {
                ngrams[chunk.key] = [:];
            }
            for item in chunk.value {
                ngrams[chunk.key]![item.key] = Double(item.value) / Double(sum);
            }
        }

        let merged: [String:Double] = (ngrams.reduce(into: [:]) { pre, cur in
            for item in cur.value {
                if item.key == "_" { continue };
                pre[item.key] = item.value;
            }   
        })
        let result = merged.sorted(by: {a,b in a.value > b.value})
            .map() { $0.key }

        return result.count > MAX_NGRAMS ? Array(result[0...MAX_NGRAMS]) : result;
    }

    private func tokenize(_ text: String) -> [String] {
        let transformedText = text.lowercased()
        // We should separate the string with the following regex
        // But Negative-Look-Back is not supported on Swift :(
        // let regex = try! Regex(#"[^\p{L}]+(?<![\x27\x60\x{2019}])"#)
         return transformedText.split(separator: " ").map {"_\($0)_"}
    }
}
