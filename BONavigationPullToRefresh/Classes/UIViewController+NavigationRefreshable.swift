//
//  UIViewController+NavigationRefreshable.swift
//  Pods
//
//  Created by Bruno Oliveira on 20/06/16.
//
//

import UIKit

public protocol NavigationPullRefreshable {
  // Configure the NavigationPullToRefresh
  func addNavigationPullToRefresh(toScrollView scrollView: UIScrollView,
                                               refreshingView: RefreshableView,
                                               startLoading: () -> Void)

  // You must call when the ViewController appears to pause loader when viewController is pushed
  func viewControllerWillShow()

  // You must call when the ViewController will disappear to pause loader when viewController is popped
  // or pushed
  func viewControllerWillDisappear()

  func endRefreshing()
}

extension NavigationPullRefreshable where Self: UIViewController {
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

// Mark: Helpers
extension UIViewController {
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
