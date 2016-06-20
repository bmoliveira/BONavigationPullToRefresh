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
class ExampleViewController: UIViewController, NavigationPullRefreshable {
  let fakeLoadingTime = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC))
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // Maximum height for the loading view
    let maxHeight: CGFloat = self.navigationController?.navigationBar.absoluteHeight ?? 10
  
    // Configurations to animate the default RefreshableView
    let configurations = DefaultRefreshingViewConfigurations(maxHeight: maxHeight,
                                                             image: UIImage(named: "sample"))
  
    let refreshableView = DefaultRefreshingView(configurations: configurations)
  
  
    addNavigationPullToRefresh(toScrollView: self.scrollView, refreshingView: refreshableView) {
      let fakeLoadingTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * NSEC_PER_SEC))
      dispatch_after(fakeLoadingTime, dispatch_get_main_queue()) {
        self.endRefreshing()
      }
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

#### DefaultRefreshingView

```swift
  // configurations is a DefaultRefreshingViewConfigurations
  DefaultRefreshingView(configurations: configurations)
```

#### DefaultRefreshingViewConfigurations

```swift
public struct DefaultRefreshingViewConfigurations {

// Maximum view Size
var maxHeight: CGFloat = 80

  // View inset
  var inset = CGPoint.zero

  // Image to be shown
  var image: UIImage?

  // Scaling option of the UIImageView
  var imageOptions = UIViewContentMode.ScaleToFill

  // Animation time
  var animationTime: NSTimeInterval = 1

  // Fade animation Time
  var animationFadeTime: NSTimeInterval = 0.5
}
```

### End refreshing

```swift
self.endRefreshing()
```

### Lifecycle
To keep the viewControllers stack lifecycle its needed to call two more methods on your ViewController:

```swift
override func viewWillAppear(animated: Bool) {
  super.viewWillAppear(animated)
  viewControllerWillShow()
}

override func viewWillDisappear(animated: Bool) {
  super.viewWillDisappear(animated)
  viewControllerWillDisappear()
}
```

### Configurations

```swift
  // Distance needed to trigger refresh
  public var triggerDistance: CGFloat = 80

```

## Author

Bruno Oliveira, bm.oliveira.dev@gmail.com

## License

BONavigationPullToRefresh is available under the MIT license. See the LICENSE file for more info.
