//
//  ScrollView+RefreshingView.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 14/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

extension UIScrollView {
  func endRefreshing() {
    state = 0
  }

  func bindPTR(startedLoading startLoading: () -> Void, updatePercentage: (CGFloat) -> Void) {

    let whenOffsetChanged: ((AnyObject?) -> Void) = { _ in
      let offset = self.contentOffset
      let inset = self.contentInset

      let realYOffset = offset.y + inset.top

      // Guard overscrolling and diferent offset
      guard realYOffset != self.currentYOffset && realYOffset <= 0 else {
        return
      }

      self.currentYOffset = realYOffset

      // Guard current state isnt already loading
      guard self.state != self.LoadingState else {
        return
      }

      var percentage =  abs(self.currentYOffset) / PTRConfiguration.instance.triggerDistance
      percentage = min(percentage, 1)

      // Guard positive percentage
      guard self.state != percentage && percentage >= 0 else {
        return
      }

      updatePercentage(percentage)
      self.state = percentage
    }


    let whenPanGestureChanged: ((AnyObject?) -> Void) = { value in
      guard let gesture = value as? Int where
        gesture == UIGestureRecognizerState.Ended.rawValue else {
          return
      }

      if self.state >= 1 {
        self.state = self.LoadingState
        startLoading()
      }
    }

    insetObserver = KVOObserver.observe(self, keyPath: "contentInset", option: .New,
                                        callback: whenOffsetChanged)

    offsetObserver = KVOObserver.observe(self, keyPath: "contentOffset", option: .New,
                                         callback: whenOffsetChanged)

    panGestureObserver = KVOObserver.observe(self, keyPath: "pan.state", option: .New,
                                             callback: whenPanGestureChanged)
  }
}

// MARK: Associated Properties and constants
extension UIScrollView {
  private struct AssociatedKeys {
    static var insetObserver = "insetObserver"
    static var offsetObserver = "offsetObserver"
    static var panGestureObserver = "panGestureObserver"
    static var currentYOffset = "currentYOffset"
    static var state = "state"
  }

  private var LoadingState: CGFloat {
    return -1
  }

  // Maximum distance to pull trigger
  private var MaxDistance: CGFloat {
    return 80
  }

  // ContentInset observer
  private var insetObserver : KVOObserver? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.insetObserver) as? KVOObserver
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.insetObserver, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  // ContentOffset Observer
  private var offsetObserver : KVOObserver? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.offsetObserver) as? KVOObserver
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.offsetObserver, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  // PanGesture Observer
  private var panGestureObserver : KVOObserver? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.panGestureObserver) as? KVOObserver
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.panGestureObserver, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  // Current scrollviewcontentoffset value
  private var currentYOffset: CGFloat {
    get {
      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.currentYOffset) as? CGFloat else {
        return 0
      }
      return value
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.currentYOffset, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }


  // Current loading state
  // -1 -> viewIsLoading
  // 0 - 100 -> Current PTR percentage
  private var state: CGFloat {
    get {
      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.state) as? CGFloat else {
        return 0
      }
      return value
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.state, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}


