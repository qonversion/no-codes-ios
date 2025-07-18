//
//  Action.swift
//  QonversionNoCodes
//
//  Created by Suren Sarkisyan on 24.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

public extension NoCodes {
  
  /// Type of the action
  enum ActionType {
    /// Unspecified action type
    case unknown
    
    /// URL action that opens the URL using SafariViewController
    case url
    
    /// Deeplink action that opens if Application can open specified deeplink
    case deeplink
    
    /// Navigation to another NoCodes screen
    case navigation
    
    /// Purchase the product
    case purchase
    
    /// Restore all purchases
    case restore
    
    /// Close current screen
    case close
    
    /// Close all NoCodes screens
    case closeAll
    
    /// Internal action for store products loading
    case loadProducts
    
    /// Internal action that indicates that the screen is ready to be shown
    case showScreen
  }

  /// Action performed in the NoCodes
  struct Action {
    /// Type of the action
    public let type: ActionType
    
    // Parameters for the action
    public let parameters: [String: Any]?
  }
  
}
