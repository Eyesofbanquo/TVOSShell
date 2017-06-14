//
//  Video.swift
//  TVOSShell
//
//  Created by Markim on 5/30/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation

protocol Video {
  var id:String { get }
  var thumbnailUri:String { get }
  var date:String { get }
  var title:String { get }
  var duration:Double { get }
  var category:DataStore.Category.Sub { get }
  
  
  
}

extension Video {
  func getTime() -> (minutes: Int, seconds: Double) {
    let seconds = duration.truncatingRemainder(dividingBy: 60.0)
    var totalDuration: Double = duration - seconds
    var minutes: Int = 0
    while totalDuration > 0 {
      minutes = minutes + 1
      totalDuration = totalDuration - 60
    }
    
    return (minutes, seconds)
  }
}
