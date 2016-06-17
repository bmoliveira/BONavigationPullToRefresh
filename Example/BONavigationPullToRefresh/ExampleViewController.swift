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

  @IBOutlet weak var scrollView: UIScrollView!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "BONavigationPullToRefresh"

    // Maximum height for the loading view
    let maxHeight: CGFloat = self.navigationController?.navigationBar.absoluteHeight ?? 10

    // Configurations to animate the default RefreshableView
    let configurations = DefaultRefreshingViewConfigurations(maxHeight: maxHeight,
                                                             image: UIImage(named: "sample"))

    let refreshableView = DefaultRefreshingView(configurations: configurations)


    addNavigationPullToRefresh(toScrollView: self.scrollView, refreshingView: refreshableView){
        let fakeLoadingTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * NSEC_PER_SEC))
        dispatch_after(fakeLoadingTime, dispatch_get_main_queue()) {
          self.endRefreshing()
        }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    viewControllerWillShow()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    viewControllerWillDisappear()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
