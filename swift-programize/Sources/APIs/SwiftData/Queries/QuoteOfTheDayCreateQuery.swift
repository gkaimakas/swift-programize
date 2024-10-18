//
//  QuoteOfTheDayCreateQuery.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Core
import Dependencies
import DTOs
import Foundation
import SwiftData

actor QuoteOfTheDayCreateQuery: Query {
    let modelExecutor: ModelExecutor
    let modelContainer: ModelContainer
    
    let dto: QuoteDTO
    let createdAt: Date
    
    init(_ dto: QuoteDTO, createdAt: Date) {
        @Dependency(\.sdManager) var sdManager
        self.modelExecutor = sdManager.modelExecutor
        self.modelContainer = sdManager.modelContainer
        
        self.dto = dto
        self.createdAt = createdAt.startOfDay()
    }
    
    func run() throws -> QuoteDTO {
        let new = QuoteOfTheDaySDM(dto, createdAt: createdAt)
        modelContext.insert(new)
        try modelContext.save()
        return QuoteDTO(
            id: .init(rawValue: new._id_),
            author: new.author,
            text: new.text
        )
    }
}
