// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-programize",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "APIs", targets: ["APIs"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "DTOs", targets: ["DTOs"]),
        .library(name: "QuoteCreate", targets: ["QuoteCreate"]),
        .library(name: "QuoteList", targets: ["QuoteList"]),
        .library(name: "QuoteOfTheDay", targets: ["QuoteOfTheDay"]),
        .library(name: "QuoteRow", targets: ["QuoteRow"]),
        .library(name: "QuoteUpdate", targets: ["QuoteUpdate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.0"),
        .package(url: "https://github.com/WeTransfer/Mocker", from: "3.0.2")
    ],
    targets: [
        .target(
            name: "APIs",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Core",
                "DTOs"
            ]
        ),
        .testTarget(
            name: "APIsTests",
            dependencies: [
                .product(name: "Mocker", package: "Mocker"),
                "APIs",
                "DTOs"
            ]
        ),
        
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .target(name: "CoreUI"),
        
        .target(
            name: "DTOs",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "Core"
            ]
        ),
        .testTarget(
            name: "DTOsTests",
            dependencies: [
                "DTOs"
            ]
        ),
        
        .target(
            name: "QuoteCreate",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "APIs",
                "Core",
                "CoreUI",
                "DTOs"
            ]
        ),
        
        .target(
            name: "QuoteList",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "APIs",
                "Core",
                "CoreUI",
                "DTOs",
                "QuoteRow"
            ]
        ),
        .testTarget(
            name: "QuoteListTests",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "APIs",
                "DTOs",
                "QuoteList",
                "QuoteRow"
            ]
        ),
        
        
        .target(
            name: "QuoteOfTheDay",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "APIs",
                "Core",
                "CoreUI",
                "DTOs"
            ]
        ),
        .target(
            name: "QuoteRow",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "APIs",
                "Core",
                "CoreUI",
                "DTOs",
                "QuoteUpdate"
            ]
        ),
        .target(
            name: "QuoteUpdate",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "APIs",
                "Core",
                "CoreUI",
                "DTOs"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
