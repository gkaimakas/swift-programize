//
//  QuoteAPI.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import Alamofire
import Core
import Dependencies
import DTOs
import Foundation

public struct QuoteAPI: Sendable {
    public var quotes: @Sendable (
    ) async throws -> [QuoteDTO]
    
    public var quoteCreate: @Sendable (
        _ text: String,
        _ author: String?
    ) async throws -> Void
    
    public var quoteUpdate: @Sendable (
        _ id: QuoteDTO.ID,
        _ text: String,
        _ author: String?
    ) async throws -> Void
    
    public var quoteDelete: @Sendable (
        _ id: QuoteDTO.ID
    ) async throws -> Void
    
    public var quoteOfTheDay: @Sendable(
        _ date: Date
    ) async throws -> QuoteDTO?
}

extension QuoteAPI: DependencyKey {
    public static var liveValue: QuoteAPI {
        @Sendable
        func quotes(
        ) async throws -> [QuoteDTO] {
            try await asyncThrowingRequest(
                Router.quotes
            )
        }
        
        @Sendable
        func quoteCreate(
            text: String,
            author: String?
        ) async throws -> Void {
            let req = QuoteCreateRequest(text: text, author: author)
            let res: Void = try await asyncThrowingRequest(
                Router.quotes,
                method: .post,
                parameters: req
            )
            
            @Dependency(\.quoteCRUDEventStream) var stream
            stream.send(event: .quoteCreated)
            
            return res
        }
        
        @Sendable
        func quoteUpdate(
            id: QuoteDTO.ID,
            text: String,
            author: String?
        ) async throws -> Void {
            let req = QuoteUpdateRequest(text: text, author: author)
            let res: Void = try await asyncThrowingRequest(
                Router.quote(id: id),
                method: .put,
                parameters: req
            )
            
            return res
        }
        
        @Sendable
        func quoteDelete(
            id: QuoteDTO.ID
        ) async throws -> Void {
            let res: Void = try await asyncThrowingRequest(
                Router.quote(id: id),
                method: .delete
            )
            
            return res
        }
        
        @Sendable
        func randomQuote(
        ) async throws -> QuoteDTO? {
            try await asyncThrowingRequest(
                Router.randomQuote
            )
        }
        
        @Sendable
        func quoteOfTheDay(
            _ date: Date
        ) async throws -> QuoteDTO? {
            guard let exisitng = try await QuoteFetchByCreatedAtQuery(createdAt: date).run() else {
                let new: QuoteDTO? = try await randomQuote()
                if let new {
                    return try await QuoteOfTheDayCreateQuery(new, createdAt: date).run()
                }
                return new
            }
            return exisitng
        }
        
        return QuoteAPI(
            quotes: quotes,
            quoteCreate: quoteCreate,
            quoteUpdate: quoteUpdate,
            quoteDelete: quoteDelete,
            quoteOfTheDay: quoteOfTheDay
        )
    }
}

extension QuoteAPI {
    enum Router: URLConvertible {
        case quotes
        case randomQuote
        case quote(id: QuoteDTO.ID)
        
        var path: String {
            switch self {
            case .quotes:
                return "/quotes"
                
            case .randomQuote:
                return "/quotes/random"
                
            case let .quote(id):
                return "/quotes/\(id.rawValue)"
            }
        }
        
        func asURL() throws -> URL {
            URL(string: "http://localhost:3001/api")!.appending(path: path)
        }
    }
}
