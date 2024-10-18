//
//  SDManager.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Dependencies
import Foundation
import SwiftData

struct SDManager {
    static let shared: SDManager = { .init() }()
    
    var modelContainer: ModelContainer
    var modelExecutor: DefaultSerialModelExecutor
    
    init(
        modelContainer: @autoclosure () -> ModelContainer,
        modelExecutor: @autoclosure () -> DefaultSerialModelExecutor
    ) {
        self.modelContainer = modelContainer()
        self.modelExecutor = modelExecutor()
    }
    
    init() {
        let mContainer = {
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            
            return try! ModelContainer(
                for: QuoteOfTheDaySDM.self,
                configurations: configuration
            )
        }()
        
        self.modelContainer = mContainer
        
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: {
            let res = ModelContext(mContainer)
            res.autosaveEnabled = false
            return res
        }())
    }
}

extension SDManager: DependencyKey, TestDependencyKey {
    static var liveValue: SDManager { .shared }
    static var testValue: SDManager {
        let modelContainer = {
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: true,
                allowsSave: true
            )
            
            return try! ModelContainer(
                for: QuoteOfTheDaySDM.self,
                configurations: configuration
            )
        }()
        
        let executor = DefaultSerialModelExecutor(modelContext: {
            let res = ModelContext(modelContainer)
            res.autosaveEnabled = false
            return res
        }())
        
        return SDManager(
            modelContainer: modelContainer,
            modelExecutor: executor
        )
    }
}
