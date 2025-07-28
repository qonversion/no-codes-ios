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
      
      // Convert FallbackScreen to JSON data and decode as NoCodes.Screen
      let screenData = try encoder.encode(fallbackScreen)
      let screen = try decoder.decode(NoCodes.Screen.self, from: screenData)
      
      logger.debug("Successfully loaded fallback screen for context key: \(contextKey)")
      return screen
      
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
      
      // Convert FallbackScreen to JSON data and decode as NoCodes.Screen
      let screenData = try encoder.encode(fallbackScreen)
      let screen = try decoder.decode(NoCodes.Screen.self, from: screenData)
      
      logger.debug("Successfully loaded fallback screen for id: \(id)")
      return screen
      
    } catch {
      logger.error("Failed to load fallback screen: \(error.localizedDescription)")
      return nil
    }
  }
  
  private func loadFallbackData() throws -> FallbackFile {
    guard let path = Bundle.main.path(forResource: fallbackFileName.replacingOccurrences(of: ".json", with: ""), ofType: "json") else {
      logger.debug("Fallback file not found: \(fallbackFileName)")
      throw FallbackError.fileNotFound
    }
    
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    
    return try decoder.decode(FallbackFile.self, from: data)
  }
  
  static func isFallbackFileAvailable(_ fileName: String = "nocodes_fallbacks.json") -> Bool {
    return Bundle.main.path(forResource: fileName.replacingOccurrences(of: ".json", with: ""), ofType: "json") != nil
  }
}

// MARK: - Errors

enum FallbackError: Error {
  case fileNotFound
  case invalidScreenData
}
