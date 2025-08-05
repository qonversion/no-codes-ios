//
//  FallbackServiceInterface.swift
//  NoCodes
//
//  Created by Suren Sarkisyan on 07.07.2025.
//  Copyright © 2025 Qonversion Inc. All rights reserved.
//

import Foundation

protocol FallbackServiceInterface {
  func loadScreen(withContextKey contextKey: String) -> NoCodes.Screen?
  func loadScreen(with id: String) -> NoCodes.Screen?
} 
