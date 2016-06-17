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
  var maxHeight: CGFloat = 80
  var inset = CGPoint.zero
  var image: UIImage?
  var imageOptions = UIViewContentMode.ScaleToFill
  var animationTime: NSTimeInterval = 1
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

public class DefaultRefreshingView: UIView, RefreshableView {

  private var configurations: DefaultRefreshingViewConfigurations

  private var firstImageView = UIImageView()
  private var secondImageView = UIImageView()
  private var animating = false

  override public var frame: CGRect {
    didSet {
      if !animating {
        updateBounds()
      } else {
        removeAllAnimations() {
          if self.animating {
            self.startRefreshing()
          }
        }
      }
    }
  }

  public init(configurations: DefaultRefreshingViewConfigurations) {
    self.configurations = configurations
    super.init(frame: CGRect.zero)

    addSubview(firstImageView)
    firstImageView.image = configurations.image
    firstImageView.contentMode = configurations.imageOptions
    firstImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

    addSubview(secondImageView)
    secondImageView.image = configurations.image
    secondImageView.contentMode = configurations.imageOptions
    secondImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

    updateBounds()
    resetFrames()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("DefaultRefreshView is only instatiated by code")
  }

  public func startRefreshing() {
    animating = true
    alpha = 1
    animate()
  }

  public func cancelRefreshing() {
    alpha = 0
  }

  
  public func endRefreshing() {
    pauseAnimation()
    UIView.animateWithDuration(configurations.animationFadeTime, delay: 0,
                               options: [.BeginFromCurrentState], animations: {
                                self.alpha = 0
      }, completion: { completed in
        self.removeAllAnimations()
        self.animating = false
    })
  }

  private func pauseAnimation() {
    let pauseTime = firstImageView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
    firstImageView.layer.speed = 0
    firstImageView.layer.timeOffset = pauseTime
    secondImageView.layer.speed = 0
    secondImageView.layer.timeOffset = pauseTime
  }

  private func removeAllAnimations(callback: (() -> ())? = nil) {
    let triggerTime = (Int64(USEC_PER_SEC) * 500)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { _ in
      self.firstImageView.layer.speed = 1
      self.secondImageView.layer.speed = 1
      self.firstImageView.layer.removeAllAnimations()
      self.secondImageView.layer.removeAllAnimations()
      callback?()
    })
  }

  private func animate() {
    if animating {
      resetFrames()
      UIView.animateWithDuration(configurations.animationTime, delay: 0,
                                 options: [.Repeat, .CurveLinear], animations: {
                                  self.firstImageView.frame.origin.x = self.frame.width
                                  self.secondImageView.frame.origin.x = 0
        }, completion: nil)
    }
  }

  public func updateLoadingItem(percentage: CGFloat) {
    alpha = 1
    let newSize = CGSize(width: bounds.width, height: configurations.maxHeight * percentage)
    firstImageView.frame.size = newSize
    secondImageView.frame.size = newSize
  }

  func resetFrames() {
    self.firstImageView.frame.origin.x = 0
    self.secondImageView.frame.origin.x = -self.firstImageView.frame.width
  }

  func updateBounds() {
    firstImageView.bounds = bounds
    firstImageView.frame.origin = CGPoint(x: self.frame.origin.x + configurations.inset.x,
                                          y: configurations.inset.y)
    secondImageView.bounds = bounds
    let secondImageX = self.frame.origin.x + configurations.inset.x - firstImageView.bounds.width
    secondImageView.frame.origin = CGPoint(x: secondImageX,
                                          y: configurations.inset.y)
  }
}
