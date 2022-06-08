# ListFlowLayout
[![Swift Version][swift-image]][swift-url]
![Issues](https://img.shields.io/github/issues/mark-kebo/ListFlowLayout)
![Forks](https://img.shields.io/github/forks/mark-kebo/ListFlowLayout)
![Stars](https://img.shields.io/github/stars/mark-kebo/ListFlowLayout)
![License](https://img.shields.io/github/license/mark-kebo/ListFlowLayout) 

FlowLayout for UICollectionView to represent cells as a list with additional click animation or loading state

## Version

1.0.0

## Installing
ListFlowLayout support [Swift Package Manager](https://www.swift.org/package-manager/).

### Swift Package Manager
``` swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "ListFlowLayout",
  platforms: [
       .iOS(.v12),
  ],
  dependencies: [
    .package(name: "ListFlowLayout", url: "https://github.com/mark-kebo/ListFlowLayout", from: "1.0.0")
  ],
  targets: [
    .target(name: "YourTestProject", dependencies: ["ListFlowLayout"])
  ]
)
```
And then import wherever needed: ```import ListFlowLayout```

#### Adding it to an existent iOS Project via Swift Package Manager

1. Using Xcode 11 go to File > Swift Packages > Add Package Dependency
2. Paste the project URL: https://github.com/mark-kebo/ListFlowLayout
3. Click on next and select the project target
4. Don't forget to set `DEAD_CODE_STRIPPING = NO` in your `Build Settings` (https://bugs.swift.org/plugins/servlet/mobile#issue/SR-11564)

If you have doubts, please, check the following links:

[How to use](https://developer.apple.com/videos/play/wwdc2019/408/)

[Creating Swift Packages](https://developer.apple.com/videos/play/wwdc2019/410/)

After successfully retrieved the package and added it to your project, just import `ListFlowLayout` and you can get the full benefits of it.

## Usage example

``` swift
import ListFlowLayout

final class YourCollectionViewCell: ListCollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.highlitedStyle = .background(UIColor.lightGray)
        self.isLoadingIndicatorStarted = true
    }
}

final class YourViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customFlowLayout = ListFlowLayout(cellSideInset: 8)
        collectionView.collectionViewLayout = customFlowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
```

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
