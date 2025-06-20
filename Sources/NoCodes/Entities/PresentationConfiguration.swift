//
//  PresentationConfiguration.swift
//  QonversionNoCodes
//
//  Created by Suren Sarkisyan on 23.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

public extension NoCodes {
  
  enum PresentationStyle {
    case popover
    case push
    case fullScreen
  }
  
  struct PresentationConfiguration {
    let animated: Bool
    let presentationStyle: NoCodes.PresentationStyle
    let statusBarHidden: Bool
    
    public init(animated: Bool, presentationStyle: NoCodes.PresentationStyle, statusBarHidden: Bool = false) {
      self.animated = animated
      self.presentationStyle = presentationStyle
      self.statusBarHidden = statusBarHidden
    }
    
    public static func defaultConfiguration() -> PresentationConfiguration {
      return PresentationConfiguration(animated: true, presentationStyle: .fullScreen)
    }
  }
  
}
