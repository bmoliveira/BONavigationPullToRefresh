//
//  PTRConfiguration.swift
//  BONavPullToRefresh
//
//  Created by Bruno Oliveira on 15/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public class PTRConfiguration {
  public static var instance: PTRConfiguration {
    return PTRConfiguration()
  }

  // Distance needed to trigger refresh
  public var triggerDistance: CGFloat = 80
}
