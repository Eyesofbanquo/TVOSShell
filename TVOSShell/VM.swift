//
//  ViewModel.swift
//  TVOSShell
//
//  Created by Markim on 5/30/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation

protocol VM: class {
  init(categories:[DataStore.Category])
  var categories:[DataStore.Category] { get }
  var data:[Video] { get }
  func addDataItem(item:Video)
  func copyData(_ vm:VM?)
  func release()
}
