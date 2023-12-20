@testable import LanguageDetector
import XCTest

final class LanguageDetectorTests: XCTestCase {
    func testGetResourceData() throws {
        let farsi = try ResourceManager.default.getResource(name: "fa")
        XCTAssertGreaterThan(farsi.frequency.count, 0)
        XCTAssertGreaterThan(farsi.nWords.count, 0)
        XCTAssertEqual(farsi.name, "fa")
    }

    func testCreate() throws {
        let detector = Detector(langs: ["fa", "en", "ar"])
        detector.addLang(["fr", "ja"])

        XCTAssertEqual(detector.loadedSubsets.count, 5)
    }

    func testEvaluate() throws {
        let detector = Detector(langs: ["fa", "en", "ar"])
        detector.addLang(["ja", "it"])
        let scoresEn = detector.evaluate(text: "Hi there fellow adventurer. how are you today?, please go and sit over there.")
        let scoresFa = detector.evaluate(text: "سلام ای پهلوان ایرانی، شنیده ام که کیفت کوک است!")
        
        XCTAssertEqual(scoresEn?.first?.0, "en")
        XCTAssertEqual(scoresFa?.first?.0, "fa")
    }

    func testStaticDetect() throws {
        let scores = Detector.detect(text: "سلام ای پهلوان ایرانی، شنیده ام که کیفت کوک است!",langs: ["fa", "en", "ar"])
        
        XCTAssertEqual(scores?.first?.0, "fa")
    }

    func testEvaluateExperimental() throws {
        let detector = Detector(langs: ["fa", "en", "ar"])
        detector.addLang(["ja", "it"])
        let scoresEn = detector.evaluate(text: "Hi there fellow adventurer.")
        let scoresFa = detector.evaluate(text: "سلام ای پهلوان ایرانی!")
        
        // These two will fail
        XCTAssertEqual(scoresEn?.first?.0, "en") // it
        XCTAssertEqual(scoresFa?.first?.0, "fa") // ar
    }
}
