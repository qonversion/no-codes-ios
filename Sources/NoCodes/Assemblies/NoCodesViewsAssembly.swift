//
//  ViewsAssembly.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 23.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

final class ViewsAssembly {

  private let miscAssembly: MiscAssembly
  private let servicesAssembly: ServicesAssembly
  private let theme: NoCodes.Theme

  init(miscAssembly: MiscAssembly, servicesAssembly: ServicesAssembly, theme: NoCodes.Theme) {
    self.miscAssembly = miscAssembly
    self.servicesAssembly = servicesAssembly
    self.theme = theme
  }

  func viewController(with screenId: String, delegate: NoCodesViewControllerDelegate, presentationConfiguration: NoCodes.PresentationConfiguration) -> NoCodesViewController {
      return NoCodesViewController(screenId: screenId, contextKey: nil, delegate: delegate, noCodesMapper: miscAssembly.noCodesMapper(), noCodesService: servicesAssembly.noCodesService(), viewsAssembly: self, logger: miscAssembly.loggerWrapper(), presentationConfiguration: presentationConfiguration, theme: theme)
  }

  func viewController(withContextKey contextKey: String, delegate: NoCodesViewControllerDelegate, presentationConfiguration: NoCodes.PresentationConfiguration) -> NoCodesViewController {
      return NoCodesViewController(screenId: nil, contextKey: contextKey, delegate: delegate, noCodesMapper: miscAssembly.noCodesMapper(), noCodesService: servicesAssembly.noCodesService(), viewsAssembly: self, logger: miscAssembly.loggerWrapper(), presentationConfiguration: presentationConfiguration, theme: theme)
  }

}
