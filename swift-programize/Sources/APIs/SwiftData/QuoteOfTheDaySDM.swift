//
//  QuoteOfTheDaySDM.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Core
import DTOs
import Foundation
import SwiftData

@Model
class QuoteOfTheDaySDM {
    
    @Attribute(.unique)
    var _id_: QuoteDTO.ID.RawValue
    var text: String
    var author: String?
    var createdAt: Date
    
    init(
        id: QuoteDTO.ID.RawValue,
        text: String,
        author: String? = nil,
        createdAt: Date
    ) {
        self._id_ = id
        self.text = text
        self.author = author
        self.createdAt = createdAt.startOfDay()
    }
    
    convenience init(
        _ dto: QuoteDTO,
        createdAt: Date
    ) {
        self.init(
            id: dto.id.rawValue,
            text: dto.text,
            author: dto.author,
            createdAt: createdAt
        )
    }
}
