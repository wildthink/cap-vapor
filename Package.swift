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
        .package(url: "https://github.com/vapor/vapor", from: "4.115.0"),
        .package(url: "https://github.com/objecthub/swift-dynamicjson.git", from: "1.0.2"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "6.0.0"),
        
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/sqlite-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-structured-queries.git", from: "0.3.0"),
        
        .package(url: "https://github.com/apple/swift-container-plugin", from: "1.0.1"),
        
        .package(url: "https://github.com/vapor/apns.git", from: "4.2.0"),
    ],
    targets: [.executableTarget(
        name: "cap-vapor",
        dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "StructuredQueries", package: "swift-structured-queries"),
            .product(name: "_StructuredQueriesSQLite", package: "swift-structured-queries"),
            .product(name: "SQLiteKit", package: "sqlite-kit"),
            .product(name: "SQLiteNIO", package: "sqlite-nio"),
            .product(name: "DynamicJSON", package: "swift-dynamicjson"),
            .product(name: "Yams", package: "yams"),
            .product(name: "VaporAPNS", package: "apns"),
        ])]
)
