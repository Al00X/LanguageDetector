@testable import LanguageDetector
import XCTest

final class LanguageDetectorTests: XCTestCase {
    func testGetResourceData() throws {
        let farsi = try ResourceManager.getResource(name: "fa")
        XCTAssertGreaterThan(farsi.frequency.count, 0)
        XCTAssertGreaterThan(farsi.nWords.count, 0)
        XCTAssertEqual(farsi.name, "fa")
    }

    func testCreate() throws {
        let detector = Detector(langs: ["fa", "en", "ar"]);
        detector.addLang(langs: ["fr", "ja"]);

        XCTAssertEqual(detector.loadedSubsets.count, 5);
    }

    func testEvaluate() throws {
        let detector = Detector(langs: ["fa", "en", "ar"])
        detector.addLang(langs: ["ja", "it"])
        let scoresEn = detector.evaluate(text: "Hi there fellow adventurer. how are you today?, please go and sit over there.");
        let scoresFa = detector.evaluate(text: "سلام ای پهلوان ایرانی، شنیده ام که کیفت کوک است!")
        
        XCTAssertEqual(scoresEn?[0].0, "en")
        XCTAssertEqual(scoresFa?[0].0, "fa")
    }

    func testStaticDetect() throws {
        let scores = Detector.detect(text: "سلام ای پهلوان ایرانی، شنیده ام که کیفت کوک است!",langs: ["fa", "en", "ar"])
        
        XCTAssertEqual(scores?[0].0, "fa")
    }
}
