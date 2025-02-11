// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let sources: [String] = ["NoCodes"]
var dependencies: [Package.Dependency] = [
    .package(url: "git@github.com:qonversion/qonversion-ios-sdk.git", from: "5.0.0")]

let package = Package(
    name: "NoCodes",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "QonversionNoCodes",
            targets: ["NoCodes"])
    ],
    dependencies: dependencies,
    targets: [.target(
                name: "NoCodes",
                dependencies: [.product(name: "Qonversion", package: "qonversion-ios-sdk")],
                path: "Sources",
                resources: [
                    .copy("../Sources/PrivacyInfo.xcprivacy")
                ])]
)
