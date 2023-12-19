@testable import LanguageDetector
import XCTest

final class LanguageDetectorTests: XCTestCase {
    func testGetResourceData() throws {
        let farsi = try ResourceManager.getResource(name: "fa")
        XCTAssertGreaterThan(farsi.frequency.count, 0)
        XCTAssertGreaterThan(farsi.nWords.count, 0)
        XCTAssertEqual(farsi.name, "fa")
    }

    func testCreateLanguageDetector() throws {
        let detector = Detector(langs: ["fa", "en", "ar"]);
        detector.addLang(langs: ["fr", "ja"]);

        XCTAssertEqual(detector.loadedSubsets.count, 5);
    }
}
