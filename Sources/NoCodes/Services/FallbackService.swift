//
//  FallbackService.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 07.07.2025.
//  Copyright © 2025 Qonversion Inc. All rights reserved.
//

import Foundation

// MARK: - Fallback File Structures

struct FallbackFile: Decodable {
  let screens: [String: FallbackScreen]
}

struct FallbackScreen: Codable {
  let id: String
  let body: String
  let context_key: String
}

final class FallbackService: FallbackServiceInterface {
  private let logger: LoggerWrapper
  private let fallbackFileName: String
  private let decoder: JSONDecoder
  private let encoder: JSONEncoder
  
  // Lazy caching
  private var cachedFallbackFile: FallbackFile?
  
  init(logger: LoggerWrapper, fallbackFileName: String = "nocodes_fallbacks.json", decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
    self.logger = logger
    self.fallbackFileName = fallbackFileName
    self.decoder = decoder
    self.encoder = encoder
  }
  
  func loadScreen(withContextKey contextKey: String) -> NoCodes.Screen? {
    do {
      let fallbackFile = try loadFallbackData()
      
      guard let fallbackScreen = fallbackFile.screens[contextKey] else {
        logger.debug("No fallback screen found for context key: \(contextKey)")
        return nil
      }
      
      return convertFallbackScreenToNoCodesScreen(fallbackScreen, identifier: contextKey)
      
    } catch {
      logger.error("Failed to load fallback screen: \(error.localizedDescription)")
      return nil
    }
  }
  
  func loadScreen(with id: String) -> NoCodes.Screen? {
    do {
      let fallbackFile = try loadFallbackData()
      
      // Search for screen with matching ID among all screens
      let matchingScreen = fallbackFile.screens.values.first { $0.id == id }
      
      guard let fallbackScreen = matchingScreen else {
        logger.debug("No fallback screen found for id: \(id)")
        return nil
      }
      
      return convertFallbackScreenToNoCodesScreen(fallbackScreen, identifier: id)
      
    } catch {
      logger.error("Failed to load fallback screen: \(error.localizedDescription)")
      return nil
    }
  }
  
  private func convertFallbackScreenToNoCodesScreen(_ fallbackScreen: FallbackScreen, identifier: String) -> NoCodes.Screen? {
    do {
      // Convert FallbackScreen to JSON data and decode as NoCodes.Screen
      let screenData = try encoder.encode(fallbackScreen)
      let screen = try decoder.decode(NoCodes.Screen.self, from: screenData)
      
      logger.debug("Successfully loaded fallback screen for identifier: \(identifier)")
      return screen
      
    } catch {
      logger.error("Failed to convert fallback screen to NoCodes.Screen: \(error.localizedDescription)")
      return nil
    }
  }
  
  private func loadFallbackData() throws -> FallbackFile {
    // Return cached data if already loaded
    if let cached = cachedFallbackFile {
      return cached
    }
    
    // Load from file if not cached
    guard let path = FallbackService.getFallbackFilePath(for: fallbackFileName) else {
      logger.debug("Fallback file not found: \(fallbackFileName)")
      throw FallbackError.fileNotFound
    }
    
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    
    let fallbackFile = try decoder.decode(FallbackFile.self, from: data)
    
    // Cache the loaded data
    cachedFallbackFile = fallbackFile
    
    logger.debug("Fallback file loaded and cached: \(fallbackFileName)")
    return fallbackFile
  }
  
  static func isFallbackFileAvailable(_ fileName: String = "nocodes_fallbacks.json") -> Bool {
    return getFallbackFilePath(for: fileName) != nil
  }
  
  private static func getFallbackFilePath(for fileName: String) -> String? {
    return Bundle.main.path(forResource: fileName.replacingOccurrences(of: ".json", with: ""), ofType: "json")
  }
}

// MARK: - Errors

enum FallbackError: Error {
  case fileNotFound
  case invalidScreenData
}
