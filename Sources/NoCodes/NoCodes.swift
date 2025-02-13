//
//  NoCodes.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 17.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation

public final class NoCodes {
  
  // MARK: - Public
  
  /// Use this variable to get the current initialized instance of the Qonversion NoCodes SDK.
  /// Please, use the variable only after initializing the SDK.
  /// - Returns: the current initialized instance of the ``NoCodes/NoCodes`` SDK
  public static let shared = NoCodes()
  private var flowCoordinator: NoCodesFlowCoordinator? = nil
  
  /// Use this function to initialize the NoCodes SDK.
  /// - Parameters:
  ///   - configuration: ``NoCodes/NoCodes/Configuration`` data for the SDK configuration.
  /// - Returns: ``NoCodes/NoCodes`` instance of the SDK.
  @discardableResult
  public static func initialize(with configuration: Configuration) -> NoCodes {
    let assembly: NoCodesAssembly = NoCodesAssembly(configuration: configuration)
    NoCodes.shared.flowCoordinator = assembly.flowCoordinator()
    
    return NoCodes.shared
  }
  
  /// se this function to set the delegate that will report what is happening inside NoCodes, what actions are being executed/failed, and so on.
  /// - Parameters:
  ///   - delegate: ``NoCodes/NoCodes/Delegate`` object.
  public func set(delegate: NoCodes.Delegate) {
    flowCoordinator?.set(delegate: delegate)
  }
  
  /// Use this function to set the screen customization delegate.
  /// - Parameters:
  ///   - delegate: screen customization ``NoCodes/NoCodes/ScreenCustomizationDelegate`` object.
  public func set(screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate) {
    flowCoordinator?.set(screenCustomizationDelegate: screenCustomizationDelegate)
  }
  
  /// Use this function to display the screen.
  /// - Parameters:
  ///   - id: identifier of the screen.
  @MainActor
  public func showNoCode(with id: String) async throws {
    try await flowCoordinator?.showNoCode(with: id)
  }
  
  /// Use this function to close all ``NoCodes/NoCodes`` screens.
  public func close() {
    flowCoordinator?.close()
  }
  
}
