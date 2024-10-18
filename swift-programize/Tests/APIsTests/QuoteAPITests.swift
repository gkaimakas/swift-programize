//
//  QuoteAPITests.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

@testable import APIs
import Alamofire
import Dependencies
import DTOs
import Foundation
import Mocker
import Testing

@Suite("QuoteAPI Tests")
final class QuoteAPITests {
    var session: Session {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [
            MockingURLProtocol.self
        ]
        
        registerMocks()
        
        return .init(configuration: config)
    }
    
    init() {}
    
    @Test("QuoteAPI.quotes returns actual quotes.")
    func quotesReturnsActualQuotes() async throws {
        try await withDependencies { values in
            values.session = self.session
        } operation: {
            let res = try await QuoteAPI.liveValue.quotes()
            #expect(res.count == 7)
        }
    }
    
    func registerMocks() {
        let url = try! QuoteAPI.Router.quotes.asURL()
        let mock = Mock(url: url, statusCode: 200, data: [.get: MockData.getProducts])
        mock.register()
    }
}
