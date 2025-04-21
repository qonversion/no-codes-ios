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
    let projectKey: String
    
    /// Delegate
    let delegate: NoCodes.Delegate?
    
    /// Screen customization delegate
    let screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate?
    
    /// Initializer of NoCodes Configuration.
    ///
    /// - Parameters:
    ///   - projectKey: Your project key from Qonversion Dashboard to setup the SDK
    ///   - delegate: delegate object.
    ///   - screenCustomizationDelegate: ``NoCodes/NoCodes/ScreenCustomizationDelegate`` screen customization delegate object.
    public init(projectKey: String, delegate: NoCodes.Delegate? = nil, screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate? = nil) {
      self.projectKey = projectKey
      self.delegate = delegate
      self.screenCustomizationDelegate = screenCustomizationDelegate
    }
    
  }
  
}
