# ACImage

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

For App integration, you should using Xcode 14 or higher, to add this package to your App target. To do this, check [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app?language=objc) about the step by step tutorial using Xcode.

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
    ACImage(imageURL, contentMode: .fill, nameInitials: nil, placeHolderImage: StaticImage.contentPlaceHolderImage.assetImage!, failureImage: StaticImage.imageDownloadfailure.assetImage!, size: size)
}
```

## Author

[Hetul](https://github.com/Hetul-aecor)
[Pinal](https://github.com/pinalaecor)

## Thanks

- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI.git)
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)

## License

ACImage is available under the MIT license. See the LICENSE file for more info.
