//
//  KVOObserver.swift
//  Pods
//
//  Created by Bruno Oliveira on 20/06/16.
//
//

import Foundation

class KVOObserver: NSObject {

  private let callback: ((AnyObject?) -> Void)
  private let observee: NSObject
  private let keyPath: String
  private let optionToObserve: NSKeyValueObservingOptions

  private init(observee: NSObject, keyPath : String, option: NSKeyValueObservingOptions,
               callback: (AnyObject?)->Void) {
    self.callback = callback
    self.observee = observee
    self.keyPath = keyPath
    self.optionToObserve = option
  }

  deinit {
    observee.removeObserver(self, forKeyPath: keyPath)
  }

  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
                                       change: [String : AnyObject]?,
                                       context: UnsafeMutablePointer<Void>) {
    switch self.optionToObserve {
    case NSKeyValueObservingOptions.New:
      self.callback(change?[NSKeyValueChangeNewKey])
    case NSKeyValueObservingOptions.Old:
      self.callback(change?[NSKeyValueChangeOldKey])
    default:
      self.callback(nil)
    }
  }

  class func observe(object: NSObject, keyPath : String, option: NSKeyValueObservingOptions,
                     callback: (AnyObject?)->Void) -> KVOObserver {

    let kvoObserver = KVOObserver(observee: object, keyPath: keyPath, option: option,
                                  callback: callback)
    object.addObserver(kvoObserver, forKeyPath: keyPath, options: option, context: nil)
    return kvoObserver
  }
}
