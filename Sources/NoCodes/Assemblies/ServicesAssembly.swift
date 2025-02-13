//
//  ServicesAssembly.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 18.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

fileprivate enum StringConstants: String {
  case baseURL = "https://api.qonversion.io/"
}

final class ServicesAssembly {
  
  private let miscAssembly: MiscAssembly
  private var deviceInfoCollectorInstance: DeviceInfoCollector?
  
  init(miscAssembly: MiscAssembly) {
    self.miscAssembly = miscAssembly
  }
  
  func noCodesService() -> NoCodesServiceInterface {
    return NoCodesService(requestProcessor: requestProcessor())
  }
  
  func requestProcessor() -> RequestProcessorInterface {
    let networkProvider: NetworkProviderInterface = networkProvider()
    let headersBuilder: HeadersBuilderInterface = miscAssembly.headersBuilder()
    let errorHandler: NetworkErrorHandlerInterface = miscAssembly.errorHandler()
    let decoder: ResponseDecoderInterface = miscAssembly.responseDecoder()
    let rateLimiter: RateLimiterInterface = miscAssembly.rateLimiter()
    
    let retriableRequestsList: [Request] = []
    
    let processor = RequestProcessor(baseURL: StringConstants.baseURL.rawValue, networkProvider: networkProvider, headersBuilder: headersBuilder, errorHandler: errorHandler, decoder: decoder, retriableRequestsList: retriableRequestsList, rateLimiter: rateLimiter)
    
    return processor
  }
  
  func networkProvider() -> NetworkProviderInterface {
    let session: URLSession = urlSession()
    let networkProvider = NetworkProvider(session: session)
    
    return networkProvider
  }
  
  func urlSession() -> URLSession {
    return URLSession.shared
  }
  
  func deviceInfoCollector() -> DeviceInfoCollectorInterface {
    if let deviceInfoCollectorInstance {
      return deviceInfoCollectorInstance
    }
    
    let deviceInfoCollector = DeviceInfoCollector()
    deviceInfoCollectorInstance = deviceInfoCollector
    
    return deviceInfoCollector
  }
  
}
