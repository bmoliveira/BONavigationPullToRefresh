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

public struct DefaultRefreshingViewConfigurations {

  // Maximum view Size
  var maxHeight: CGFloat = 80

  // View inset
  var inset = CGPoint.zero

  // Image to be shown
  var image: UIImage?

  // Scaling option of the UIImageView
  var imageOptions = UIViewContentMode.ScaleToFill

  // Animation time
  var animationTime: NSTimeInterval = 1

  // Fade animation Time
  var animationFadeTime: NSTimeInterval = 0.5

  public init (maxHeight: CGFloat = 80, inset: CGPoint = CGPoint.zero, image: UIImage? = nil,
               imageOptions: UIViewContentMode = .ScaleToFill, animationTime: NSTimeInterval = 1,
               animationFadeTime: NSTimeInterval = 0.5) {
    self.maxHeight = maxHeight
    self.inset = inset
    self.image = image
    self.animationTime = animationTime
    self.animationFadeTime = animationFadeTime
  }
}
