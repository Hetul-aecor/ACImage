# ACImage

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Hetul-aecor/ACImage/graphs/commit-activity)
[![License](https://img.shields.io/github/license/Hetul-aecor/ACimage)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS-green)](https://github.com/Hetul-aecor/ACImage)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-green.svg)](https://swift.org/package-manager/)
[![GitHub contributors](https://badgen.net/github/contributors/Hetul-aecor/ACImage)](https://github.com/Hetul-aecor/ACImage/graphs/contributors/)
[![GitHub pull-requests](https://img.shields.io/github/issues-pr/Hetul-aecor/ACImage.svg)](https://github.com/Hetul-aecor/ACImage/pull/)

## What's for
A feature packed image view which allows you to focus on important tasks in your work and leave all image management to ACImage.

## Features

- [x] Name Intials 
- [x] Animated Image
- [x] Local Image
- [x] URL Image
- [x] Place holder Image
- [x] Failure Image
- [x] Youtube Thumbnail from URL

## Version

This framework follows [Semantic Versioning](https://semver.org/). Each source-break API changes will bump to a major version.

## Contribution

All issue reports, feature requests, contributions, and GitHub stars are welcomed. Hope for active feedback and promotion if you find this framework useful.

## Requirements

+ Xcode 14.2+
+ iOS 14+

## Installation

#### Swift Package Manager

ACImage is available only through [Swift Package Manager](https://swift.org/package-manager/).

+ For App integration

For App integration, you should using Xcode 14.2 or higher, to add this package to your App target. To do this, check [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app?language=objc) about the step by step tutorial using Xcode.

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/pinalaecor/ACImage.git", from: "1.0.9")
    ],
)
```
## Usage

### Using `ACImage` to show image

```swift
var body: some View {
    ACImage(imageURL, contentMode: .fill, nameInitials: nil, placeHolderImage: Constant.contentPlaceHolderImage, failureImage: Constant.imageDownloadfailure, size: imageSize)
        .clipShape(Circle())
        .background(
            Circle()
                .stroke(strokeColor, lineWidth: strokeWidth)
        )
        .foregroundColor(textColor)
        .font(.custom(fontName, size: fontSize, relativeTo: relativeTo))
}
```

+ PlaceHolder UI

![PlaceHolder View](https://github.com/pinalaecor/ACImage/blob/3aa4cfc4208397a8581474662a9bf42b6789475c/Images/placheHolderImage.png)

+ Image view UI

![Downloaded Image View](https://github.com/pinalaecor/ACImage/blob/3aa4cfc4208397a8581474662a9bf42b6789475c/Images/DownloadedImage.png)

+ Initials UI

![Initials View](https://github.com/pinalaecor/ACImage/blob/3aa4cfc4208397a8581474662a9bf42b6789475c/Images/initialsImage.png)

+ Failure UI

![Failure Image.png View](https://github.com/pinalaecor/ACImage/blob/3aa4cfc4208397a8581474662a9bf42b6789475c/Images/failureImage.png)

## Author

- [Hetul](https://github.com/Hetul-aecor)
- [Pinal](https://github.com/pinalaecor)

## Thanks

- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI.git)
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)

## Contributing

If you have suggestions for how this framework could be improved, or want to report a bug, open an issue! We'd love all and any contributions.

For more, check out the [Contributing Guide](CONTRIBUTING.md).

## License

ACImage is available under the MIT license. See the LICENSE file for more info.
