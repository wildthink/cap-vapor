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
    // Serve Public/index.html at “/”
    app.get { req in
        try await req.fileio.asyncStreamFile(at: app.directory.publicDirectory + "/index.html")
    }

    // Example: serve Public/about.html at “/about”
    app.get("about") { req in
        try await req.fileio.asyncStreamFile(at: app.directory.publicDirectory + "/about.html")
    }

    // Member login handler
    app.post("login") { req -> EventLoopFuture<Response> in
        let form = try req.content.decode(LoginForm.self)
        // TODO: authenticate form.email & form.password
        print("authenticate \(form)")

        // e.g. check against DB, set session, etc.
        return req.eventLoop.future(req.redirect(to: "/"))
    }

    // Email signup handler
    app.post("subscribe") { req -> EventLoopFuture<Response> in
        let form = try req.content.decode(SignupForm.self)
        // TODO: add form.email to your mailing list
        print("subscribe \(form.email)")
        return req.eventLoop.future(req.redirect(to: "/"))
    }

    // Catch-all: serve any file under /Public
    app.get(.catchall) { req -> Response in
        let path = req.parameters.getCatchall().joined(separator: "/")
        return try await req.fileio.asyncStreamFile(at: app.directory.publicDirectory + "/" + path)
    }
}

// Form data models
struct LoginForm: Content {
    let email: String
    let password: String
}

struct SignupForm: Content {
    let email: String
}

func _routes(_ app: Application) throws {
    
//    app.get(".well-known", "apple-app-site-association") { req -> Response in
//        print(#line, "app.get", req.url)
//        let file = req.application.directory.publicDirectory + ".well-known/apple-app-site-association"
//        let data = try Data(contentsOf: URL(fileURLWithPath: file))
//        var headers = HTTPHeaders()
//        headers.add(name: .contentType, value: "application/json")
//        return Response(status: .ok, headers: headers, body: .init(data: data))
//    }
    
    app.get { req async in
        print(#line, "app.get", req.url)
        if let db = app.database.connection,
           let row = try? await db.query("SELECT 1") {
            return "Hello SQLite, from Vapor on \(myos)\nRow: \(row)"
        } else {
            return "Hello World, from Vapor on \(myos)\n"
        }
    }
}
