//
//  AsyncResult.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

public enum AsyncResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
    
    public init(catching action: () async throws(Failure) -> Success) async {
        do {
            self = try await .success(action())
        } catch let err {
            self = .failure(err)
        }
    }
}
