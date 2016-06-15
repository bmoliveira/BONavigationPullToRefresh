//
//  ViewController.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 06/09/2016.
//  Copyright (c) 2016 Bruno Oliveira. All rights reserved.
//

import UIKit
import BONavigationPullToRefresh

class ExampleViewController: UIViewController, UIScrollViewDelegate {
  let fakeLoadingTime = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC))

  @IBOutlet weak var scrollView: UIScrollView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let view = DefaultRefreshingView()
    view.backgroundColor = UIColor.blueColor()
    self.navigationController?
      .configureRefreshingItem(scrollView: self.scrollView, refreshingView: view) {
        dispatch_after(self.fakeLoadingTime, dispatch_get_main_queue()) {
          self.navigationController?.endRefreshing()
        }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.viewControllerWillShow()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.viewControllerWillDisappear()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
