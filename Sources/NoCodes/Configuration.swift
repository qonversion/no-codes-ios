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

    /// Optional custom fallback file name. If not provided, defaults to "nocodes_fallbacks.json"
    let fallbackFileName: String?

    /// Theme mode for No-Code screens. Controls how screens adapt to light/dark themes.
    /// Defaults to `.auto` which follows the device's system appearance.
    let theme: NoCodes.Theme

    /// Initializer of NoCodes Configuration.
    ///
    /// - Parameters:
    ///   - projectKey: Your project key from Qonversion Dashboard to setup the SDK
    ///   - delegate: delegate object.
    ///   - screenCustomizationDelegate: ``NoCodes/NoCodes/ScreenCustomizationDelegate`` screen customization delegate object.
    ///   - fallbackFileName: Optional custom fallback file name. If not provided, defaults to "nocodes_fallbacks.json"
    ///   - theme: Theme mode for No-Code screens. Defaults to `.auto`.
    public init(projectKey: String, delegate: NoCodes.Delegate? = nil, screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate? = nil, fallbackFileName: String? = nil, theme: NoCodes.Theme = .auto) {
      self.projectKey = projectKey
      self.delegate = delegate
      self.screenCustomizationDelegate = screenCustomizationDelegate
      self.fallbackFileName = fallbackFileName
      self.theme = theme
    }

  }

}
