//
//  Query.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation
import SwiftData

protocol Query: ModelActor {
    associatedtype Result: Sendable
    
    func run() throws -> Result
}
