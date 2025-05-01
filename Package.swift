// swift-tools-version: 6.0

//===----------------------------------------------------------------------===//
// Copyright (c) 2025 WildThink, Inc
// All Rights Reserved
//
// See LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "community-action-platform",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.102.0"),
        .package(url: "https://github.com/objecthub/swift-dynamicjson.git", from: "1.0.2"),
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/sqlite-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-container-plugin", from: "1.0.0"),
    ],
    targets: [.executableTarget(
        name: "cap-vapor",
        dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "SQLiteKit", package: "sqlite-kit"),
            .product(name: "SQLiteNIO", package: "sqlite-nio"),
            .product(name: "DynamicJSON", package: "swift-dynamicjson"),
        ])]
)
