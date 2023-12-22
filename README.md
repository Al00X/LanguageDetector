# Language Detector

|                                             Version                                             |                                        Minimum Swift Version                                        |                                                                   License                                                                   |
|:-----------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------:|
| [![Version](https://img.shields.io/github/v/release/Al00X/LanguageDetector)](https://swift.org) | [![Minimum Swift Version](http://img.shields.io/badge/Swift-5.9-brightgreen.svg)](https://swift.org) | [![License](https://img.shields.io/packagist/l/patrickschur/language-detection.svg?style=flat-square)](https://opensource.org/licenses/MIT) |

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
## Supported languages
The library currently supports 110 languages. You can see the list of the languages [here](Sources/LanguageDetector/Resources/subsets).

---

<br>

This package is inspired by [php-language-detection](https://github.com/patrickschur/language-detection)

<br>
