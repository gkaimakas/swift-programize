//
//  QuoteDTOTests.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

@testable import DTOs
import Foundation
import Testing

@Suite("QuoteDTO Tests")
struct QuoteDTOTests {
    
    @Test("QuoteDTO is decoded from a JSON Response")
    func quoteIsDecoded() async throws {
        let data = MockData.getProducts
        try #require(data.isEmpty == false)
        let res = try JSONDecoder.programize.decode([QuoteDTO].self, from: data)
        #expect(res.isEmpty == false)
        #expect(res.count == 7)
    }
}

