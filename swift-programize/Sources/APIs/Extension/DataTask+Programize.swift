//
//  DataTask.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Alamofire

extension DataTask {
    func ignoreResult() async throws -> Void {
        let _ = await self.response
        return ()
    }
    
    func value() async throws -> Value {
        let res = await self.response
        switch res.result {
        case let .success(value):
            return value
            
        case .failure:
            throw ProgramizeError()
        }
    }
}
