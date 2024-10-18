//
//  QuoteListTests.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

@testable import QuoteList
@testable import APIs
import ConcurrencyExtras
import ComposableArchitecture
import DTOs
import Foundation
import QuoteRow
import Testing

@Suite("QuoteList Tests")
@MainActor
struct QuoteListTests: Sendable {
    var mockedQuotes: [QuoteDTO]
    
    init() throws {
        let data = MockData.getProducts
        try #require(data.isEmpty == false)
        mockedQuotes = try JSONDecoder.programize.decode([QuoteDTO].self, from: data)
        try #require(mockedQuotes.isEmpty == false)
    }
    
    @Test("Test that .task fetches all the quotes and populates quoteRows")
    func taskFetchesQuotesAndPopulatesQuoteRows() async throws {
        let state = QuoteList.State()
        let stream = APIs.Stream<QuoteCRUDEvent>()
        let store = TestStore(initialState: state) {
            QuoteList()
        } withDependencies: { dependencies in
            dependencies.quoteCRUDEventStream = stream
            dependencies.quoteAPI.quotes = { mockedQuotes }
        }
        
        let task = await store.send(.task) {
            $0.quotesStatus = .executing
        }
        
        await store.receive(\.fetchQuotesCompleted.success) {
            $0.quotesStatus = .completed(.success)
            $0.quoteRows = .init(uniqueElements: mockedQuotes.map(QuoteRow.State.init))
        }
        
        await task.cancel()
    }
    
    @Test("Creating a Quote causes the quote list to refresh")
    func createQuoteCausesRefresh() async throws {
        
        let mutableQuotes = LockIsolated<[QuoteDTO]>([])
        
        let state = QuoteList.State()
        let stream = APIs.Stream<QuoteCRUDEvent>()
        
        let store = TestStore(initialState: state) {
            QuoteList()
        } withDependencies: {
            $0.quoteCRUDEventStream = stream
            $0.quoteAPI.quotes = { mutableQuotes.value }
        }
        
        let task = await store.send(.task) {
            $0.quotesStatus = .executing
        }
        
        await store.receive(\.fetchQuotesCompleted.success) {
            $0.quotesStatus = .completed(.success)
            $0.quoteRows = .init(uniqueElements: [].map(QuoteRow.State.init))
        }
        
        mutableQuotes.setValue([mockedQuotes.first!])
        
        stream.send(event: .quoteCreated)
        
        await store.receive(\.fetchQuotesCompleted.success) {
            $0.quotesStatus = .completed(.success)
            $0.quoteRows = .init(uniqueElements: [mockedQuotes.first!].map(QuoteRow.State.init))
        }
        
        await task.cancel()
    }
    
    @Test("Deleting a Quote casues the quote list to refresh")
    func deleteQuoteCausesRefresh() async throws {
        var state = QuoteList.State()
        state.quoteRows = .init(uniqueElements: mockedQuotes.map(QuoteRow.State.init))
        
        let store = TestStore(initialState: state) {
            QuoteList()
        } withDependencies: {
            $0.quoteAPI.quotes = { mockedQuotes.dropLast() }
        }
        
        let last = mockedQuotes.last
        try #require(last != nil)
        
        await store.send(.quoteRow(.element(id: last!.id, action: .delegate(.quoteDeleted)))) {
            $0.quoteRows = .init(uniqueElements: (mockedQuotes.dropLast()).map(QuoteRow.State.init))
        }
    }
}
