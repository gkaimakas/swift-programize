//
//  QuoteDTO.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import Dependencies
import Foundation

public struct QuoteDTO: Hashable, Codable, Identifiable, Sendable {
    public var id: Id
    public var author: String?
    public var text: String
    
    public init(
        id: Id,
        author: String? = nil,
        text: String
    ) {
        self.id = id
        self.author = author
        self.text = text
    }
}

public extension QuoteDTO {
    struct Id: Equatable, Hashable, Codable, Comparable, RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible, Sendable {
        
        public static func < (
            lhs: Self,
            rhs: Self
        ) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        public static var empty: Id { Id(rawValue: "") }
        public static var random: Id {
            @Dependency(\.uuid) var uuid
            return Id(rawValue: uuid().uuidString)
        }
        
        public var rawValue: String
        public var description: String { rawValue }
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }
        
        public init(from decoder: Decoder) throws {
            do {
                try self.init(
                    rawValue: decoder
                        .singleValueContainer()
                        .decode(String.self)
                )
            } catch {
                try self.init(
                    rawValue: .init(
                        from: decoder
                    )
                )
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }
}
