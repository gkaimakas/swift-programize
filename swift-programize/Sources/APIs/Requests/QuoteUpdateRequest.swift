//
//  QuoteUpdateRequest.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

struct QuoteUpdateRequest: Codable, Sendable {
    let text: String
    let author: String?
}
