//
//  NoCodesService.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 18.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

class NoCodesService: NoCodesServiceInterface {
  
  private let requestProcessor: RequestProcessorInterface
  private let fallbackService: FallbackServiceInterface?
  
  init(requestProcessor: RequestProcessorInterface, fallbackService: FallbackServiceInterface? = nil) {
    self.requestProcessor = requestProcessor
    self.fallbackService = fallbackService
  }
  
  func loadScreen(with id: String) async throws -> NoCodes.Screen {
    do {
      let request = Request.getScreen(id: id)
      let screen: NoCodes.Screen = try await requestProcessor.process(request: request, responseType: NoCodes.Screen.self)
      
      return screen
    } catch {
      throw NoCodesError(type: .screenLoadingFailed, message: nil, error: error)
    }
  }
  
  func loadScreen(withContextKey contextKey: String) async throws -> NoCodes.Screen {
    do {
      let request = Request.getScreenByContextKey(contextKey: contextKey)
      let screen: NoCodes.Screen = try await requestProcessor.process(request: request, responseType: NoCodes.Screen.self)
      
      return screen
    } catch {
      // Try fallback if available and error is network-related
      if let fallbackService = fallbackService,
         isNetworkError(error) {
        if let fallbackScreen = fallbackService.loadScreen(withContextKey: contextKey) {
          return fallbackScreen
        }
      }
      
      throw NoCodesError(type: .screenLoadingFailed, message: nil, error: error)
    }
  }
  
  private func isNetworkError(_ error: Error) -> Bool {
    // Check if error is network-related (not API business logic errors)
    if let noCodesError = error as? NoCodesError {
      switch noCodesError.type {
      case .invalidRequest, .invalidResponse, .internal, .critical:
        return true
      case .screenLoadingFailed, .productsLoadingFailed, .productNotFound, .authorizationFailed, .rateLimitExceeded:
        return false
      case .unknown, .sdkInitializationError:
        return true
      }
    }
    
    // Check for common network errors
    let nsError = error as NSError
    return nsError.domain == NSURLErrorDomain || 
           nsError.domain == "com.apple.dt.XCTestErrorDomain" ||
           error.localizedDescription.contains("network") ||
           error.localizedDescription.contains("connection") ||
           error.localizedDescription.contains("timeout")
  }
  
}
