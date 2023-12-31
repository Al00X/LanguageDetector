@testable import LanguageDetector
import XCTest

final class LanguageDetectorTests: XCTestCase {
    func testGetResourceData() throws {
        let farsi = try ResourceManager.default.getResource(name: "fa")
        XCTAssertGreaterThan(farsi.frequency.count, 0)
        XCTAssertEqual(farsi.name, "fa")
    }
    
    func testCreate() throws {
        let detector = try LanguageDetector(languages: ["fa", "en", "ar"])
        try detector.addLanguages(["fr", "ja"])
        
        XCTAssertEqual(detector.loadedSubsets.count, 5)
    }
    
    func testEvaluate() throws {
        let detector = try LanguageDetector(languages: ["fa", "en", "ar", "ja", "it"])
        let a = try detector.evaluate(text: "Hi there fellow adventurer. how are you today?, please go and sit over there.")
        let b = try detector.evaluate(text: "سلام ای پهلوان ایرانی، شنیده ام که کیفت کوک است!")
        let c = try detector.evaluate(text: "Hi there fellow adventurer.")
        let d = try detector.evaluate(text: "سلام ای پهلوان ایرانی!")
        let e = try detector.evaluate(text: "سلام داداش");
        let f = try detector.evaluate(text: "Yo ma boi");
        
        XCTAssertEqual(a?.first?.0, "en")
        XCTAssertEqual(b?.first?.0, "fa")
        XCTAssertEqual(c?.first?.0, "en")
        XCTAssertEqual(d?.first?.0, "fa")
        XCTAssertEqual(e?.first?.0, "fa")
        XCTAssertEqual(f?.first?.0, "en")
    }
    
    func testStaticDetect() throws {
        let lang = try LanguageDetector.detect(text: "سلام ای پهلوان ایرانی، شنیده ام که کیفت کوک است!",languages: ["fa", "en", "ar"])
        
        XCTAssertEqual(lang, "fa")
    }
    
    func testEvaluationConsistency() throws {
        let detector = try LanguageDetector(languages: ["fa"])
        
        let a1 = try detector.evaluate(text: "سلام داداش چه خبر")
        let a2 = try detector.evaluate(text: "سلام داداش چه خبر")
        // Used OrderedDictionary to fix the inconsistency problem
        
        XCTAssertEqual(a1?.first?.1, a2?.first?.1)
    }
    
    func testEvaluateVariations() throws {
        let detector = try LanguageDetector(languages: ["fa", "en", "ar"])
        
        let a1 = try detector.evaluate(text: "سلام داداش چه خبر")
        let a2 = try detector.evaluate(text: "سلام داداش، چه خبر؟")
        let a3 = try detector.evaluate(text: " سلام داداش، چه خبر")
        let a4 = try detector.evaluate(text: "سلام داداش چه خبر؟")
        let a5 = try detector.evaluate(text: "سلام داداش چه خبر؟ <3   ")
        let a6 = try detector.evaluate(text: "سلام داداش چه خبر؟ 09123456789")
        // The results above are different, and the a1's score is greater than others...
        // This should never happen! the original transformer is changed to prevent this error
        
        XCTAssertEqual(a1?.first?.1, a2?.first?.1)
        XCTAssertEqual(a1?.first?.1, a3?.first?.1)
        XCTAssertEqual(a1?.first?.1, a4?.first?.1)
        XCTAssertEqual(a1?.first?.1, a5?.first?.1)
        XCTAssertEqual(a1?.first?.1, a6?.first?.1)
    }
}
