import Foundation

public enum LanguageDetectorError: Error {
    case emptyLanguageList
    case resourceNotFound(language: String)
}

