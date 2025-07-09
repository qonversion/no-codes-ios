//
//  FallbackService.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 17.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

protocol FallbackServiceInterface {
  func loadScreen(withContextKey contextKey: String) -> NoCodes.Screen?
}

final class FallbackService: FallbackServiceInterface {
  
  private let logger: LoggerWrapper
  private let fallbackFileName: String
  
  init(logger: LoggerWrapper, fallbackFileName: String = "nocodes_fallbacks.json") {
    self.logger = logger
    self.fallbackFileName = fallbackFileName
  }
  
  func loadScreen(withContextKey contextKey: String) -> NoCodes.Screen? {
    do {
      let fallbackData = try loadFallbackData()
      let screens = fallbackData["screens"] as? [String: [String: Any]] ?? [:]
      
      guard let screenData = screens[contextKey] else {
        logger.debug("No fallback screen found for context key: \(contextKey)")
        return nil
      }
      
      let screen = try parseScreen(from: screenData)
      logger.debug("Successfully loaded fallback screen for context key: \(contextKey)")
      return screen
      
    } catch {
      logger.error("Failed to load fallback screen: \(error.localizedDescription)")
      return nil
    }
  }
  
  private func loadFallbackData() throws -> [String: Any] {
    guard let path = Bundle.main.path(forResource: fallbackFileName.replacingOccurrences(of: ".json", with: ""), ofType: "json") else {
      logger.debug("Fallback file not found: \(fallbackFileName)")
      throw FallbackError.fileNotFound
    }
    
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    
    guard let dictionary = json as? [String: Any] else {
      throw FallbackError.invalidFormat
    }
    
    return dictionary
  }
  
  private func parseScreen(from data: [String: Any]) throws -> NoCodes.Screen {
    guard let id = data["id"] as? String,
          let html = data["html"] as? String,
          let contextKey = data["context_key"] as? String else {
      throw FallbackError.invalidScreenData
    }
    
    return NoCodes.Screen(id: id, html: html, contextKey: contextKey)
  }
}

// MARK: - Errors

enum FallbackError: Error {
  case fileNotFound
  case invalidFormat
  case invalidScreenData
}

// MARK: - Screen Extension

extension NoCodes.Screen {
  init(id: String, html: String, contextKey: String) {
    self.id = id
    self.html = html
    self.contextKey = contextKey
  }
} 