//
//  Configuration.swift
//  Qonversion
//
//  Created by Suren Sarkisyan on 28.03.2024.
//

import Foundation

extension NoCodes {
  
  /// Struct used to set the SDK main and additional configurations.
  public struct Configuration {
    
    /// Your project key from Qonversion Dashboard to setup the SDK
    let apiKey: String
    
    /// Delegate
    let delegate: NoCodes.Delegate?
    
    /// Screen customization delegate
    let screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate?
    
    /// Initializer of NoCodes Configuration.
    ///
    /// - Parameters:
    ///   - apiKey: Your project key from Qonversion Dashboard to setup the SDK
    ///   - delegate: delegate object.
    ///   - screenCustomizationDelegate: screen customization delegate object.
    public init(apiKey: String, delegate: NoCodes.Delegate? = nil, screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate? = nil) {
      self.apiKey = apiKey
      self.delegate = delegate
      self.screenCustomizationDelegate = screenCustomizationDelegate
    }
    
  }
  
}
