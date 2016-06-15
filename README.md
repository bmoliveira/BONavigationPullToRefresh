# BONavigationPullToRefresh

[![Version](https://img.shields.io/cocoapods/v/BONavigationPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/BONavigationPullToRefresh)
[![License](https://img.shields.io/cocoapods/l/BONavigationPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/BONavigationPullToRefresh)
[![Platform](https://img.shields.io/cocoapods/p/BONavigationPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/BONavigationPullToRefresh)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The Demo project requires iOS9

## Requirements


## Installation

BONavigationPullToRefresh is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BONavigationPullToRefresh"
```

To start using simply configure the current ViewController import:

```swift
import BONavigationPullToRefresh
```

### Simple usecase

```swift 
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
```

### RefreshingView
The refreshingView is a UIView that conforms to protocol RefreshableView:

```swift
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
```

You can use the DefaultRefreshingView that only updates its alpha as it is shown in the example.

### End refreshing

```swift
self.navigationController?.endRefreshing()
```

### Lifecycle
To keep the viewControllers stack lifecycle its needed to call two more methods on your ViewController:

```swift
override func viewWillAppear(animated: Bool) {
  super.viewWillAppear(animated)
  navigationController?.viewControllerWillShow()
}

override func viewWillDisappear(animated: Bool) {
  super.viewWillDisappear(animated)
  navigationController?.viewControllerWillDisappear()
}
```

### Configurations

```swift
// Distance needed to trigger refresh
PTRConfiguration.sharedInstance.maxDistance = 80

// Loading view height
PTRConfiguration.sharedInstance.barHeight = 10

```

## Author

Bruno Oliveira, bm.oliveira.dev@gmail.com

## License

BONavigationPullToRefresh is available under the MIT license. See the LICENSE file for more info.
