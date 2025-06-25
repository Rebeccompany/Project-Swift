//
//  Worker.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 25/06/25.
//

public protocol Worker: Actor {
    associatedtype Input
    associatedtype Output

    func execute(_ input: Input) async throws -> Output
}

public protocol SyncWorker {
    associatedtype Input
    associatedtype Output

    func execute(_ input: Input) throws -> Output
}

extension SyncWorker {
    public func executeOptional(_ input: Input) -> Output? {
        try? execute(input)
    }
}

extension Worker {
    public func executeOptional(_ input: Input) async -> Output? {
        try? await execute(input)
    }
}
