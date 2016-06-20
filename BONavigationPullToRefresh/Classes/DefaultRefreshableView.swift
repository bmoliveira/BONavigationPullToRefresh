//
//  DefaultRefreshableView.swift
//  Pods
//
//  Created by Bruno Oliveira on 20/06/16.
//
//

import UIKit

public class DefaultRefreshingView: UIView, RefreshableView {

  private var configurations: DefaultRefreshingViewConfigurations

  private var firstImageView = UIImageView()
  private var secondImageView = UIImageView()
  private var animating = false
  private var startedAnimation: NSDate? = nil

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
    startedAnimation = NSDate()
    animating = true
    alpha = 1
    animate()
  }

  public func cancelRefreshing() {
    alpha = 0
  }

  public func endRefreshing() {
    let timeTillTrigger = Double(NSDate().timeIntervalSinceDate(startedAnimation ?? NSDate()))

    var triggerTime: Double = min(configurations.animationTime, timeTillTrigger)

    if timeTillTrigger < configurations.animationTime {
      triggerTime = configurations.animationTime
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64(NSEC_PER_SEC) * Int64(triggerTime))),
                   dispatch_get_main_queue(), { _ in
                    self.pauseAnimation()
                    UIView.animateWithDuration(self.configurations.animationFadeTime, delay: 0,
                      options: [.BeginFromCurrentState], animations: {
                        self.alpha = 0
                      }, completion: { completed in
                        self.removeAllAnimations {
                          self.animating = false
                        }
                    })
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
    let triggerTime = (Int64(USEC_PER_SEC) * 10)
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
    guard !animating else {
      return
    }

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
