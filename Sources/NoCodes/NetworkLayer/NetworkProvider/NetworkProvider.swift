//
//  NetworkProvider.swift
//  Qonversion
//
//  Created by Suren Sarkisyan on 02.02.2024.
//

import Foundation

class NetworkProvider: NetworkProviderInterface {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    convenience init(timeout: TimeInterval? = 60.0) {
        let config = URLSessionConfiguration.default
        timeout.map {
            config.timeoutIntervalForRequest = $0
            config.timeoutIntervalForResource = $0
        }
        let session = URLSession(configuration: config)
        self.init(session: session)
    }
    
    func send(request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
