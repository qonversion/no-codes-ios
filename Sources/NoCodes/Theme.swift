//
//  Theme.swift
//  NoCodes
//
//  Created by Claude on 16.01.2026.
//  Copyright © 2026 Qonversion Inc. All rights reserved.
//

import Foundation

extension NoCodes {

  /// Enum representing the theme mode for No-Code screens.
  /// Use this to control how screens adapt to light/dark themes.
  public enum Theme: String {
    /// Automatically follow the device's system appearance (default).
    /// The screen will use light theme in light mode and dark theme in dark mode.
    case auto = "auto"

    /// Force light theme regardless of device settings.
    case light = "light"

    /// Force dark theme regardless of device settings.
    case dark = "dark"
  }

}
