//
//  QuoteFetchByCreatedAtQuery.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//
import Dependencies
import DTOs
import Foundation
import SwiftData

actor QuoteFetchByCreatedAtQuery: Query {
    let modelExecutor: ModelExecutor
    let modelContainer: ModelContainer
    
    let descriptor: FetchDescriptor<QuoteOfTheDaySDM>
    
    init(createdAt: Date) {
        @Dependency(\.sdManager) var sdManager
        self.modelExecutor = sdManager.modelExecutor
        self.modelContainer = sdManager.modelContainer
        
        let date = createdAt.startOfDay()
        
        descriptor = {
            var res = FetchDescriptor<QuoteOfTheDaySDM>(
                predicate: #Predicate { $0.createdAt == date }
            )
            res.fetchLimit = 1
            return res
        }()
    }
    
    func run() throws -> QuoteDTO? {
        if let res = try modelContext.fetch(descriptor).first {
            return QuoteDTO(
                id: .init(rawValue: res._id_),
                author: res.author,
                text: res.text
            )
        }
        
        return nil
    }
}
