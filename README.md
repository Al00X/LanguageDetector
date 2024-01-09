# Language Detector

[![Version](https://img.shields.io/github/v/release/Al00X/LanguageDetector)](https://swift.org) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAl00X%2FLanguageDetector%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/google/generative-ai-swift) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAl00X%2FLanguageDetector%2Fbadge%3Ftype%3Dplatforms)](xxxx) [![License](https://img.shields.io/packagist/l/patrickschur/language-detection.svg?style=flat-square)](https://opensource.org/licenses/MIT)
### Detect languages of any given text with high accuracy! 

This library can take a given text and detect its language using the database previously generated in the training phase.

---
## Installation

To use this package, you need to set it up as a package dependency in `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/Al00X/LanguageDetector.git", from: "2.0.0")
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "LanguageDetector", package: "language-detector")
      ]
    )
  ]
)
```

---
## Usage

You can either instantiate the class or use it statically.

### Instance Use
```swift

let detector = LanguageDetector(languages: ["en", "it", "fr", "ar"])

// add more languages
detector.addLanguages(languages: ["es", "de"])

// detect
let result = detector.evaluate(text: "Hi there!") // [(String, Int)]

return result.first.0 // en

```

### Static Use
```swift
let result = LanguageDetector.detect(text: "I'm on static", languages: ["en", "fr", "es"]) // String

return result // en

```

---
## Supported languages
The library currently supports 110 languages. You can see the list of the languages [here](Sources/LanguageDetector/Resources/subsets).

---

<br>

This package is inspired by [php-language-detection](https://github.com/patrickschur/language-detection)

<br>
