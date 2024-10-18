//
//  ProgramizeApp.swift
//  Programize
//
//  Created by George Kaimakas on 18/10/24.
//

import ComposableArchitecture
import Core
import SwiftUI

@main
struct ProgramizeApp: App {
    var store: StoreOf<Root>
    
    var body: some Scene {
        WindowGroup {
            RootView(store)
        }
    }
    
    init() {
        self.store = .init(initialState: Root.State(), reducer: {
            Root()
        })
        
        print(Bundle.main.programizeConfig.baseURL)
    }
}
