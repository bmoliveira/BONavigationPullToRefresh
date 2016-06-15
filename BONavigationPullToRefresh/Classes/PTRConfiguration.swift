//
//  PTRConfiguration.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 15/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public class PTRConfiguration {
  public static var sharedInstance: PTRConfiguration {
    return PTRConfiguration()
  }

  // Distance needed to trigger refresh
  public var maxDistance: CGFloat = 80

  // Loading view height
  public var barHeight: CGFloat = 10
}
