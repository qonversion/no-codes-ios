//
//  Delegate.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 17.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation
import UIKit

extension NoCodes {
  
  public protocol Delegate {
    
    /// Return a source ViewController for navigation
    func controllerForNavigation() -> UIViewController?
    
    /// Called when NoCodes screen is shown
    /// - Parameters:
    ///   - id: Screen identifier
    func noCodesHasShownScreen(id: String)
    
    /// Called when NoCodes flow starts executing an action
    /// - Parameters:
    ///   - action: ``NoCodes/NoCodes/Action``
    func noCodesStartsExecuting(action: NoCodes.Action)
    
    /// Called when NoCodes flow fails to execute an action
    /// - Parameters:
    ///   - action: ``NoCodes/NoCodes/Action``
    ///   - error: error details
    func noCodesFailedToExecute(action: NoCodes.Action, error: Error?)
    
    /// Called when NoCodes flow finishes executing an action
    /// - Parameters:
    ///   - action: ``NoCodes/NoCodes/Action``
    /// For example, if the user made a purchase then action.type == .purchase
    func noCodesFinishedExecuting(action: NoCodes.Action)
    
    /// Called when NoCodes flow is finished and the NoCodes screen is closed
    func noCodesFinished()
    
    /// Called when NoCodes screen loading failed
    /// Don't forget to close the screen using `NoCodes.shared.close()`
    /// - Parameters:
    ///   - error: error details
    func noCodesFailedToLoadScreen(error: Error?)
    
  }
  
  public protocol ScreenCustomizationDelegate {
    
    /// The function should return the screen presentation configuration used to present the first screen in the chain.
    func presentationConfigurationForScreen(contextKey: String) -> NoCodes.PresentationConfiguration
    
    /// The function should return the screen presentation configuration used to present the first screen in the chain.
    /// Consider displaying screens using context keys. If so, the delegate method with contextKey will be called.
    func presentationConfigurationForScreen(id: String) -> NoCodes.PresentationConfiguration
    
    /// View for popover presentation style for iPad. A new popover will be presented from this view
    /// Used only for screenPresentationStyle == .popover for iPad.
    /// You can omit implementing this delegate function if you do not support iPad or do not use popover presentation style.
    func viewForPopoverPresentation() -> UIView?
    
  }
  
}

public extension NoCodes.Delegate {
  
  func controllerForNavigation() -> UIViewController? {
    return nil
  }
  
  func noCodesHasShownScreen(id: String) {
    
  }
  
  func noCodesStartsExecuting(action: NoCodes.Action) {
    
  }
  
  func noCodesFailedToExecute(action: NoCodes.Action) {
    
  }
  
  func noCodesFinishedExecuting(action: NoCodes.Action) {
    
  }
  
  func noCodesFinished() {
    
  }
  
  func noCodesFailedToLoadScreen(error: Error?) {
    
  }
  
}

public extension NoCodes.ScreenCustomizationDelegate {
  
  func presentationConfigurationForScreen(id: String) -> NoCodes.PresentationConfiguration {
    return NoCodes.PresentationConfiguration.defaultConfiguration()
  }
  
  func presentationConfigurationForScreen(contextKey: String) -> NoCodes.PresentationConfiguration {
    return NoCodes.PresentationConfiguration.defaultConfiguration()
  }
  
  func viewForPopoverPresentation() -> UIView? {
    return nil
  }
  
}
