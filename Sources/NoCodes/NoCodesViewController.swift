//
//  NoCodesViewController.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 23.12.2024.
//  Copyright © 2024 Qonversion Inc. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SafariServices
import Qonversion

enum Constants: String {
  case url
  case deeplink
  case screenId
  case productId
  case setProducts
  case cancelActionTitle = "Ok"
  case errorTitle = "Error"
}

protocol NoCodesViewControllerDelegate {
  
  func noCodesShownScreen(id: String)
  
  func noCodesStartsExecuting(action: NoCodes.Action)
  
  func noCodesFailedExecuting(action: NoCodes.Action, error: Error?)
  
  func noCodesFinishedExecuting(action: NoCodes.Action)
  
  func noCodesFinished()
}

final class NoCodesViewController: UIViewController {
  
  private var webView: WKWebView!
  private var activityIndicator: UIActivityIndicatorView!
  private var screen: NoCodes.Screen?
  private var noCodesService: NoCodesServiceInterface!
  private var noCodesMapper: NoCodesMapperInterface!
  private var viewsAssembly: ViewsAssembly!
  private var delegate: NoCodesViewControllerDelegate!
  private var logger: LoggerWrapper!
  
  init(screen: NoCodes.Screen, delegate: NoCodesViewControllerDelegate, noCodesMapper: NoCodesMapperInterface, noCodesService: NoCodesServiceInterface, viewsAssembly: ViewsAssembly, logger: LoggerWrapper) {
    self.screen = screen
    self.noCodesMapper = noCodesMapper
    self.noCodesService = noCodesService
    self.viewsAssembly = viewsAssembly
    self.delegate = delegate
    self.logger = logger
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let screen else { return logger.error(LoggerInfoMessages.screenLoadingFailed.rawValue) }
    
    delegate.noCodesShownScreen(id: screen.id)
    
    let userContentController = WKUserContentController()
    userContentController.add(self, name: "noCodesMessageHandler")
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController;
    
    configuration.allowsInlineMediaPlayback = true
    configuration.allowsAirPlayForMediaPlayback = true
    configuration.mediaTypesRequiringUserActionForPlayback = []
    configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
    
    webView = WKWebView(frame: .zero, configuration: configuration)
    
    webView.scrollView.bounces = false
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.contentInsetAdjustmentBehavior = .never
    
    webView.scrollView.showsHorizontalScrollIndicator = false
    webView.scrollView.delegate = self
    view.addSubview(webView)
    
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .lightGray
    activityIndicator.hidesWhenStopped = true
    view.addSubview(activityIndicator)
    
    webView.loadHTMLString(screen.html, baseURL: nil)
    
    view.layoutSubviews()
    webView.setNeedsLayout()
    webView.layoutIfNeeded()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    activityIndicator.center = view.center
    webView.frame = view.frame
  }
  
  func close() {
    close(action: nil)
  }
  
}

extension NoCodesViewController: WKScriptMessageHandler {
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let body = message.body as? [String: Any] else { return }
    
    let action: NoCodes.Action = noCodesMapper.map(rawAction: body)
    
    if action.type != .loadProducts {
      delegate.noCodesStartsExecuting(action: action)
    }
    
    switch action.type {
    case .loadProducts:
      handle(loadProductsAction: action)
    case .close:
      handle(closeAction: action)
    case .closeAll:
      finishAndClose(action: action)
    case .url:
      handle(urlAction: action)
    case .deeplink:
      handle(deepLinkAction: action)
    case .navigation:
      handle(navigationAction: action)
    case .purchase:
      handle(purchaseAction: action)
    case .restore:
      handle(restoreAction: action)
    default: break
    }
  }
  
}

extension NoCodesViewController {
  
  private func send(event: String, data: String) async {
    let _ = try? await webView.evaluateJavaScript("window.dispatchEvent(new CustomEvent(\"\(event)\",  {detail: \(data)} ))")
  }
  
  private func handle(closeAction: NoCodes.Action) {
    if self.navigationController?.viewControllers.count ?? 0 > 1 {
      navigationController?.popViewController(animated: true)
      delegate.noCodesFinishedExecuting(action: closeAction)
      if let firstExternalViewController: UIViewController = firstExternalViewController(),
         let externalIndex: Int = navigationController?.viewControllers.firstIndex(of: firstExternalViewController),
         let viewControllersCount: Int = navigationController?.viewControllers.count,
         externalIndex == viewControllersCount - 1 {
        delegate.noCodesFinished()
      }
    } else {
      finishAndClose(action: closeAction)
    }
  }
  
  private func handle(loadProductsAction: NoCodes.Action) {
    Task {
      guard let productIds: [String] = loadProductsAction.parameters?["productIds"] as? [String],
            let products: [String: Qonversion.Product] = try? await Qonversion.shared().products()
      else { return logger.error(LoggerInfoMessages.productsLoadingFailed.rawValue) }
      
      let filteredProducts: [String: Qonversion.Product] = products.filter { productIds.contains($0.key) }
      guard !filteredProducts.isEmpty else { return }
      
      let productsInfo: [String: Any] = noCodesMapper.map(products: filteredProducts)
      
      guard let data = try? JSONSerialization.data(withJSONObject: productsInfo, options: []),
            let jsString = String(data: data, encoding: .utf8)
      else { return logger.error(LoggerInfoMessages.productsLoadingFailed.rawValue) }
      await send(event: Constants.setProducts.rawValue, data: jsString)
    }
  }
  
  private func handle(urlAction: NoCodes.Action) {
    guard let urlString: String = urlAction.parameters?[Constants.url.rawValue] as? String,
          let url = URL(string: urlString) else {
      logger.error(LoggerInfoMessages.urlHandlingFailed.rawValue)
      return delegate.noCodesFailedExecuting(action: urlAction, error: nil)
    }
    
    let safariVC = SFSafariViewController(url: url)
    navigationController?.present(safariVC, animated: true)
    delegate.noCodesFinishedExecuting(action: urlAction)
  }
  
  private func handle(deepLinkAction: NoCodes.Action) {
    guard let deepLinkString: String = deepLinkAction.parameters?[Constants.deeplink.rawValue] as? String,
          let url = URL(string: deepLinkString) else {
      logger.error(LoggerInfoMessages.deeplingHandlingFailed.rawValue)
      return delegate.noCodesFailedExecuting(action: deepLinkAction, error: nil)
    }
    
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    } else {
      delegate.noCodesFailedExecuting(action: deepLinkAction, error: nil)
      logger.error(LoggerInfoMessages.deeplingHandlingFailed.rawValue)
      close(action: deepLinkAction)
    }
  }
  
  private func handle(purchaseAction: NoCodes.Action) {
    guard let productId: String = purchaseAction.parameters?[Constants.productId.rawValue] as? String else { return }
    activityIndicator.startAnimating()
    Task {
      do {
        try await Qonversion.shared().purchase(productId)
        activityIndicator.stopAnimating()
        finishAndClose(action: purchaseAction)
      } catch {
        logger.error(error.localizedDescription)
        activityIndicator.stopAnimating()
        delegate.noCodesFailedExecuting(action: purchaseAction, error: error)
        showAlert(title: Constants.errorTitle.rawValue, message: error.localizedDescription)
      }
    }
  }
  
  private func handle(restoreAction: NoCodes.Action) {
    activityIndicator.startAnimating()
    Task {
      do {
        let _ = try await Qonversion.shared().restore()
        finishAndClose(action: restoreAction)
        activityIndicator.stopAnimating()
      } catch {
        logger.error(error.localizedDescription)
        activityIndicator.stopAnimating()
        delegate.noCodesFailedExecuting(action: restoreAction, error: error)
        showAlert(title: Constants.errorTitle.rawValue, message: error.localizedDescription)
      }
    }
  }
  
  private func handle(navigationAction: NoCodes.Action) {
    guard let screenId: String = navigationAction.parameters?[Constants.screenId.rawValue] as? String else { return }
    
    activityIndicator.startAnimating()
    Task {
      do {
        let screen: NoCodes.Screen = try await noCodesService.loadScreen(with: screenId)
        activityIndicator.stopAnimating()
        let viewController = viewsAssembly.viewController(with: screen, delegate: delegate)
        navigationController?.pushViewController(viewController, animated: true)
        delegate.noCodesFinishedExecuting(action: navigationAction)
      } catch {
        logger.error(LoggerInfoMessages.screenLoadingFailed.rawValue)
        activityIndicator.stopAnimating()
        delegate.noCodesFailedExecuting(action: navigationAction, error: error)
        showAlert(title: Constants.errorTitle.rawValue, message: error.localizedDescription)
      }
    }
  }
  
  private func finishAndClose(action: NoCodes.Action) {
    delegate.noCodesFinishedExecuting(action: action)
    close(action: action)
  }
  
  private func close(action: NoCodes.Action?) {
    if navigationController?.presentingViewController != nil {
      dismiss(animated: true) {
        self.delegate.noCodesFinished()
      }
    } else {
      guard let vcToPop: UIViewController = firstExternalViewController() else { return }
      navigationController?.popToViewController(vcToPop, animated: true)
      delegate.noCodesFinished()
    }
  }
  
  private func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: Constants.cancelActionTitle.rawValue, style: .cancel, handler: handler)
    alert.addAction(action)
    
    navigationController?.present(alert, animated: true)
  }
  
  private func firstExternalViewController() -> UIViewController? {
    let currentViewControllers: [UIViewController]? = navigationController?.viewControllers
    let firstExternalVC: UIViewController? = currentViewControllers?.last(where: { !$0.isKind(of: Self.self) })
    
    return firstExternalVC
  }
  
}

extension NoCodesViewController: UIScrollViewDelegate {
  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    scrollView.pinchGestureRecognizer?.isEnabled = false
  }
}
