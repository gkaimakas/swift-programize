//
//  Result.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

public extension Result {
    init(action: () async throws(Failure) -> Success) async {
        do {
            let res = try await action()
            self = .success(res)
        } catch {
            self = .failure(error)
        }
    }
}

public func typedResult<Success, Failure>(
    _ action: () async throws(Failure) -> Success
) async -> Result<Success, Failure> where Failure: Error {
    do {
        let res = try await action()
        return .success(res)
    } catch {
        return .failure(error)
    }
}
