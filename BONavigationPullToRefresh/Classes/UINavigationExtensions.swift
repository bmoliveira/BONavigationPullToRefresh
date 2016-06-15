//
//  Classes.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 14/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

extension UINavigationController {

  // You must call when the ViewController appears to pause loader when viewController is pushed
  public func viewControllerWillShow() {
    guard navigationItem.refreshingView is UIView else {
      print("Invalid view was set on navigation item")
      return
    }

    configureRefreshingItem()

    if navigationItem.refreshing {
      navigationItem.refreshingView?.startRefreshing()
    }
  }

  // You must call when the ViewController will disappear to pause loader when viewController is popped
  // or pushed
  public func viewControllerWillDisappear() {
    guard let view = navigationItem.refreshingView as? UIView else {
      print("Invalid view was set on navigation item")
      return
    }

    view.removeFromSuperview()

    if navigationItem.refreshing {
      navigationItem.refreshingView?.cancelRefreshing()
    }
  }

  private func configureRefreshingItem() {
    guard let refreshingView = navigationItem.refreshingView as? UIView else {
      print("Refreshing view must be a UIView")
      return
    }

    if refreshingView.superview != nil {
      refreshingView.removeFromSuperview()
    }

    navigationBar.addSubview(refreshingView)
    refreshingView.frame = CGRect(x: self.navigationBar.bounds.minX,
                        y: self.navigationBar.bounds.maxY,
                        width: self.navigationBar.bounds.width,
                        height: PTRConfiguration.sharedInstance.barHeight)
    refreshingView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
  }
}

extension UINavigationController {

  // Con
  public func configureRefreshingItem(scrollView scrollView: UIScrollView, refreshingView: RefreshableView,
                                          startLoading: () -> Void) {

    guard refreshingView is UIView else {
      print("Refreshing view must be a UIView")
      return
    }

    navigationItem.ptrScrollview = scrollView
    navigationItem.refreshingView = refreshingView
    configureRefreshingItem()

    navigationItem.ptrScrollview?.bindPTR(
      startedLoading: {
        self.navigationItem.refreshing = true
        self.navigationItem.refreshingView?.startRefreshing()
        startLoading()
      },
      updatePercentage: { percentage in
        self.navigationItem.refreshingView?.updateLoadingItem(percentage)
    })
  }

  public func endRefreshing() {
    self.navigationItem.refreshingView?.endRefreshing()
    self.navigationItem.refreshing = false
    self.navigationItem.ptrScrollview?.endRefreshing()
  }
}


// MARK: Associated Properties and constants
extension UINavigationItem {
  private struct AssociatedKeys {
    static var refreshingView = "ptrAssociatedRefreshingView"
    static var boundScrollView = "ptrAssociatedScrollView"
    static var refreshing = "ptrAssociatedrefreshing"
  }

  // ContentInset observer
  var refreshing : Bool {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.refreshing) as? Bool ?? false
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.refreshing, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  // ContentInset observer
  var ptrScrollview : UIScrollView? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.boundScrollView) as? UIScrollView
    }
    set(value) {
      objc_setAssociatedObject(self, &AssociatedKeys.boundScrollView, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  var refreshingView : RefreshableView? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.refreshingView) as? RefreshableView
    }
    set(value) {
      guard let value = value as? UIView else {
        return
      }
      objc_setAssociatedObject(self, &AssociatedKeys.refreshingView, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
