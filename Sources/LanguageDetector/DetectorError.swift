import Foundation

enum DetectorError: Error {
    case emptyLanguageList
    case resourceNotFound(language: String)
}

