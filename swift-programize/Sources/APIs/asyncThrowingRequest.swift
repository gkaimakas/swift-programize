//
//  asyncThrowingRequest.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Alamofire
import Dependencies
import DTOs
import Foundation

@Sendable
func asyncThrowingRequest<Value>(
    _ convertible: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    interceptor: RequestInterceptor? = nil,
    requestModifier: Session.RequestModifier? = nil
) async throws -> Value where Value: Decodable & Sendable {
    
    @Dependency(\.session) var session
    
    return try await session
        .request(
            convertible,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier
        )
        .validate()
        .serializingDecodable(
            Value.self,
            decoder: JSONDecoder.programize
        )
        .value()
}

@Sendable
func asyncThrowingRequest(
    _ convertible: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    interceptor: RequestInterceptor? = nil,
    requestModifier: Session.RequestModifier? = nil
) async throws -> Void {
    
    @Dependency(\.session) var session
    
    return try await session
        .request(
            convertible,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier
        )
        .validate()
        .serializingData()
        .ignoreResult()
}

@Sendable
func asyncThrowingRequest<Value, Parameters>(
    _ convertible: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoder: ParameterEncoder = JSONParameterEncoder.programize,
    headers: HTTPHeaders? = nil,
    interceptor: RequestInterceptor? = nil,
    requestModifier: Session.RequestModifier? = nil
) async throws -> Value where Value: Decodable & Sendable, Parameters: Encodable & Sendable {
    
    @Dependency(\.session) var session
    
    return try await session
        .request(
            convertible,
            method: method,
            parameters: parameters,
            encoder: encoder,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier
        )
        .validate()
        .serializingDecodable(
            Value.self,
            decoder: JSONDecoder.programize
        )
        .value()
}

@Sendable
func asyncThrowingRequest<Parameters>(

    _ convertible: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoder: ParameterEncoder = JSONParameterEncoder.programize,
    headers: HTTPHeaders? = nil,
    interceptor: RequestInterceptor? = nil,
    requestModifier: Session.RequestModifier? = nil
) async throws -> Void where Parameters: Encodable & Sendable {
    
    @Dependency(\.session) var session
    
    return try await session
        .request(
            convertible,
            method: method,
            parameters: parameters,
            encoder: encoder,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier
        )
        .validate()
        .serializingData()
        .ignoreResult()
}
