//
//  WorkStatus.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import Foundation

/// Describes the state of a concurrent action (most commonly http requests).
public enum WorkStatus {
    case idle
    case executing
    case completed(Result)
    
    public var isIdle: Bool {
        guard case self = .idle else { return false }
        return true
    }
    
    public var isExecuting: Bool {
        guard case self = .executing else { return false }
        return true
    }
    
    public init() {
        self = .idle
    }
    
    mutating
    public func start() {
        self = .executing
    }
    
    mutating
    public func success() {
        self = .completed(.success)
    }
    
    mutating
    public func failure(error: Error) {
        self = .completed(.failure(error))
    }
    
    mutating
    public func reset() {
        self = .idle
    }
}

public extension WorkStatus {
    enum Result: Equatable, Hashable, Sendable {
        public static func == (lhs: WorkStatus.Result, rhs: WorkStatus.Result) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
                
            case let (.failure(errA), .failure(errB)):
                return errA.localizedDescription == errB.localizedDescription
                
            case _:
                return false
            }
        }
        
        case success
        case failure(Error)
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .success:
                hasher.combine(0)
                
            case let .failure(err):
                hasher.combine(err.localizedDescription)
            }
        }
    }
}

extension WorkStatus:
    Equatable,
    Hashable,
    Codable,
    Sendable {
    
    enum CodingKeys: String, CodingKey {
        case root
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(true, forKey: .root)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .root:
            self = .idle
            
        case .none:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unable to decode enum."
                )
            )
            
        }
    }
}
