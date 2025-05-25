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
        app.http.server.configuration.port = 8080 // 443 8443

        // TLS configuration
        let certPath = "/Users/jason/.certs/clarke.local.pem"
        let keyPath = "/Users/jason/.certs/clarke.local-key.pem"

//        app.http.server.configuration.hostname = "localhost"
        // if HTTPS
        app.http.server.configuration.port = 443
        app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
            certificateChain: [.certificate(try .init(file: certPath, format: .pem))],
            privateKey: .privateKey(try .init(file: keyPath, format: .pem)))
//            privateKey: .file(keyPath))
//            .forServer(certificateChain: [.certificate(.file(certPath))], privateKey: .file(keyPath))
        
        
//        for (k, v) in ProcessInfo.processInfo.environment {
//            print("\(k): \(v)")
//        }
//        let connection = try await SQLiteConnection.open(storage: .memory)
//        app.database.connection = connection

//        app.middleware.use(Tracer())
        let aasa = AASAMiddleware()
        app.middleware.use(aasa)

        // Serves files from `Public/` directory
        app.directory.publicDirectory = "/Users/jason/dev/site"
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

final class Tracer: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        let response = try await next.respond(to: request)
        print("TRACE: \(request.url)")
        return response
    }
}

final class AASAMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        let response = try await next.respond(to: request)
//        print("AASA: \(request.url)")
        if request.url.path == "/.well-known/apple-app-site-association" {
            response.headers.replaceOrAdd(name: .contentType, value: "application/json")
        }
        if request.url.path.hasSuffix(".json") {
            response.headers.replaceOrAdd(name: .contentType, value: "application/json")
        }
        return response
    }
}
