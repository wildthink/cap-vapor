//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftContainerPlugin open source project
//
// Copyright (c) 2025 Apple Inc. and the SwiftContainerPlugin project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftContainerPlugin project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import Vapor

let myos = ProcessInfo.processInfo.operatingSystemVersionString

func routes(_ app: Application) throws {
    app.get { req async in
        if let db = app.database.connection,
           let row = try? await db.query("SELECT 1") {
            return "Hello SQLite, from Vapor on \(myos)\nRow: \(row)"
        } else {
            return "Hello World, from Vapor on \(myos)\n"
        }
    }
}
