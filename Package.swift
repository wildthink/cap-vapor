// swift-tools-version: 6.0

//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftContainerPlugin open source project
//
// Copyright (c) 2024 Apple Inc. and the SwiftContainerPlugin project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftContainerPlugin project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "community-action-platform",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.102.0"),
        .package(url: "https://github.com/objecthub/swift-dynamicjson.git", from: "1.0.2"),
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/sqlite-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-container-plugin", from: "0.5.0"),
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
