//
//  NoCodesFlowCoordinator.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 17.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation
import UIKit

final class NoCodesFlowCoordinator {
  
  private var delegate: NoCodes.Delegate?
  private var screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate?
  private let noCodesService: NoCodesServiceInterface
  private let viewsAssembly: ViewsAssembly
  private var currentVC: NoCodesViewController?
  private var logger: LoggerWrapper!
  
  init(delegate: NoCodes.Delegate?, screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate?, noCodesService: NoCodesServiceInterface, viewsAssembly: ViewsAssembly, logger: LoggerWrapper) {
    self.delegate = delegate
    self.screenCustomizationDelegate = screenCustomizationDelegate
    self.noCodesService = noCodesService
    self.viewsAssembly = viewsAssembly
    self.logger = logger
  }
  
  func set(delegate: NoCodes.Delegate) {
    self.delegate = delegate
  }
  
  func set(screenCustomizationDelegate: NoCodes.ScreenCustomizationDelegate) {
    self.screenCustomizationDelegate = screenCustomizationDelegate
  }
  
  func close() {
    currentVC?.close()
  }
  
  @MainActor
  func showNoCode(with id: String) {
    let viewController: NoCodesViewController = viewsAssembly.viewController(with: id, delegate: self)
    currentVC = viewController
    
    let presentationConfiguration: NoCodes.PresentationConfiguration = screenCustomizationDelegate?.presentationConfigurationForScreen(id: id) ?? NoCodes.PresentationConfiguration.defaultConfiguration()
    
    showNoCode(viewController, presentationConfiguration)
  }
  
  @MainActor
  func showNoCode(withContextKey contextKey: String) {
    let viewController: NoCodesViewController = viewsAssembly.viewController(withContextKey: contextKey, delegate: self)
    currentVC = viewController
    
    let presentationConfiguration: NoCodes.PresentationConfiguration = screenCustomizationDelegate?.presentationConfigurationForScreen(contextKey: contextKey) ?? NoCodes.PresentationConfiguration.defaultConfiguration()
    
    showNoCode(viewController, presentationConfiguration)
  }
  
  private func showNoCode(_ viewController: NoCodesViewController, _ presentationConfiguration: NoCodes.PresentationConfiguration) {
    guard let presentationViewController: UIViewController = delegate?.controllerForNavigation() ?? topLevelViewController() else { return }
    
    if presentationConfiguration.presentationStyle == .push {
      presentationViewController.navigationController?.pushViewController(viewController, animated: presentationConfiguration.animated)
    } else {
      let presentationStyle: UIModalPresentationStyle = presentationConfiguration.presentationStyle == .popover ? .popover : .fullScreen
      if presentationStyle == .popover {
        viewController.modalPresentationStyle = presentationStyle
        let sourceView: UIView? = screenCustomizationDelegate?.viewForPopoverPresentation()
        
        if let sourceView {
          viewController.popoverPresentationController?.sourceView = sourceView
          viewController.popoverPresentationController?.sourceRect = sourceView.bounds
        } else {
          viewController.popoverPresentationController?.permittedArrowDirections = .up
          viewController.popoverPresentationController?.sourceRect = CGRect(x: CGRectGetMidX(presentationViewController.view.bounds), y: CGRectGetMidY(presentationViewController.view.bounds), width: 0, height: 0)
          viewController.popoverPresentationController?.sourceView = presentationViewController.view
        }
        
        presentationViewController.present(viewController, animated: presentationConfiguration.animated)
      } else {
        let navigationController = NoCodesNavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = presentationStyle
        presentationViewController.present(navigationController, animated: presentationConfiguration.animated)
      }
    }
  }
}

// MARK: - NoCodesViewControllerDelegate

extension NoCodesFlowCoordinator: NoCodesViewControllerDelegate {
  
  func noCodesHasShownScreen(id: String) {
    delegate?.noCodesHasShownScreen(id: id)
  }
  
  func noCodesStartsExecuting(action: NoCodes.Action) {
    delegate?.noCodesStartsExecuting(action: action)
  }
  
  func noCodesFailedToExecute(action: NoCodes.Action, error: Error?) {
    delegate?.noCodesFailedToExecute(action: action, error: error)
  }
  
  func noCodesFinishedExecuting(action: NoCodes.Action) {
    delegate?.noCodesFinishedExecuting(action: action)
  }
  
  func noCodesFinished() {
    delegate?.noCodesFinished()
  }
  
  func noCodesFailedToLoadScreen() {
    delegate?.noCodesFailedToLoadScreen()
  }
  
}

// MARK: - Private

extension NoCodesFlowCoordinator {
  
  private func topLevelViewController() -> UIViewController? {
      var controller = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    while controller?.presentedViewController != nil {
      controller = controller?.presentedViewController
    }
    
    return controller
  }
  
}
