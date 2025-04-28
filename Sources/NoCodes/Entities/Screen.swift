//
//  Screen.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 20.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

extension NoCodes {
  
  struct Screen: Decodable {
    let id: String
    let html: String
    let contextKey: String
    
    private enum CodingKeys: String, CodingKey {
      // After adding any keys here, duplicate them in the ResponseCodingKeys
      case id
      case body
      case context_key
    }
    
    private enum ResponseCodingKeys: String, CodingKey {
      // Getting screen by id works via legacy API. By context key - via the new, they have different response structure,
      // so the keys are duplicated to support both.
      case data
      case id
      case body
      case context_key
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
      if let screenContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: ResponseCodingKeys.data) {
        id = try screenContainer.decode(String.self, forKey: .id)
        html = try screenContainer.decode(String.self, forKey: .body)
        contextKey = try screenContainer.decode(String.self, forKey: .context_key)
      } else {
        id = try container.decode(String.self, forKey: .id)
        html = try container.decode(String.self, forKey: .body)
        contextKey = try container.decode(String.self, forKey: .context_key)
      }
    }
  }
  
}
