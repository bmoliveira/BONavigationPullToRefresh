//
//  RefreshableView.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 15/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public protocol RefreshableView {
  // View will start refreshing
  func startRefreshing()

  // Loading has beed canceled due to ViewController disapear
  func cancelRefreshing()

  // Loading has finished successfully
  func endRefreshing()

  // View needs to be updated to the percentage of loading given (bettween 0 - 1)
  func updateLoadingItem(percentage: CGFloat)
}

public class DefaultRefreshingView: UIView, RefreshableView {
  public func startRefreshing() {
    alpha = 1
  }

  public func cancelRefreshing() {
    alpha = 0
  }

  public func endRefreshing() {
    alpha = 0
  }

  public func updateLoadingItem(percentage: CGFloat) {
    alpha = percentage
  }
}
