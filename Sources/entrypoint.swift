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

import Vapor
import SQLiteNIO
import SQLKit

@main
enum Entrypoint {
    static func main() async throws {
        let env = try Environment.detect()
        let app = try await Application.make(env)
        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = 8080

        
//        for (k, v) in ProcessInfo.processInfo.environment {
//            print("\(k): \(v)")
//        }
        let connection = try await SQLiteConnection.open(storage: .memory)
        app.database.connection = connection

        // Serves files from `Public/` directory
        let fileMiddleware = FileMiddleware(
            publicDirectory: "/Users/jason/dev/site"
//            publicDirectory: app.directory.publicDirectory
        )
        app.middleware.use(fileMiddleware)
        
        do {
            try await configure(app)
            try await app.execute()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
}

// MARK: SQLite Support - jmj
extension Application {
    public var database: Database {
        .init(application: self)
    }

    public struct Database {
        public let application: Application
        public var connection: SQLiteConnection? {
            get { self.application.storage[Key.self] }
            nonmutating set { self.application.storage[Key.self] = newValue }
        }
        
        struct Key: StorageKey, Sendable {
            typealias Value = SQLiteConnection
        }
    }
}

