//
//  Classes.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 14/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

extension UIViewController {
  // You must call when the ViewController appears to pause loader when viewController is pushed
  public func viewControllerWillShow() {
    guard let refreshingView = navigationItem.refreshingView as? UIView else {
      print("Invalid view was set on navigation item")
      return
    }

    refreshingView.alpha = 0
    if navigationItem.refreshing {
      navigationItem.refreshingView?.startRefreshing()
    } else if refreshingView.superview == nil {
      addViewToNavigationBar(refreshingView)
    }
  }

  // You must call when the ViewController will disappear to pause loader when viewController is popped
  // or pushed
  public func viewControllerWillDisappear() {
    guard let refreshingView = navigationItem.refreshingView as? UIView else {
      print("Invalid view was set on navigation item")
      return
    }

    refreshingView.alpha = 1
    if navigationItem.refreshing {
      navigationItem.refreshingView?.cancelRefreshing()
    } else if refreshingView.superview != nil {
      refreshingView.removeFromSuperview()
    }
  }

  private func configureRefreshingItem(navigationItem: UINavigationItem) {
    guard let refreshingView = navigationItem.refreshingView as? UIView else {
      print("Refreshing view must be a UIView")
      return
    }

    if refreshingView.superview != nil {
      refreshingView.removeFromSuperview()
    }

    addViewToNavigationBar(refreshingView)

    let width = navigationController?.navigationBar.bounds.width ?? 0
    let absoluteY = navigationController?.navigationBar.absoluteY ?? 0
    let minX = navigationController?.navigationBar.bounds.minX ?? 0

    refreshingView.frame = CGRect(x: minX,
                                  y: -absoluteY,
                                  width: width,
                                  height: 10)

    refreshingView.clipsToBounds = false
    refreshingView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
  }

  private func addViewToNavigationBar(view: UIView) {
    navigationController?.navigationBar.insertSubview(view, atIndex: 1)
  }
}


// Add PullToRefresh to scrollview
extension UIViewController {
  public func addNavigationPullToRefresh(toScrollView scrollView: UIScrollView,
                                                      refreshingView: RefreshableView,
                                                      startLoading: () -> Void) {

    guard refreshingView is UIView else {
      print("Refreshing view must be a UIView")
      return
    }

    navigationItem.ptrScrollview = scrollView
    navigationItem.refreshingView = refreshingView
    configureRefreshingItem(navigationItem)

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

extension UINavigationBar {

  public var absoluteY: CGFloat {
    let frame = self.superview?.convertRect(self.frame, toView: nil)
    return frame?.origin.y ?? 0
  }

  public var absoluteHeight: CGFloat {
    let frame = self.superview?.convertRect(self.frame, toView: nil)
    return (frame?.size.height ?? 0) + absoluteY
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
