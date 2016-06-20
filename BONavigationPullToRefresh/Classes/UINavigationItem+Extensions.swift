//
//  UINavigationItem+Extensions.swift
//  Pods
//
//  Created by Bruno Oliveira on 20/06/16.
//
//

import UIKit

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
