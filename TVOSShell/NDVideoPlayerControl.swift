//
//  NDVideoPlayerControl.swift
//  TVOSShell
//
//  Created by Markim on 6/12/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NDVideoPlayerControl: UIView {
  
  @IBOutlet weak var icon: UILabel!
  @IBOutlet weak var text: UILabel!
  
  override var canBecomeFocused: Bool {
    return true
  }
  
  override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
    return true
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    super.didUpdateFocus(in: context, with: coordinator)
    
    if self.isFocused {
      icon.textColor = UIColor.init(hex: "304cb2")
      text.textColor = UIColor.init(hex: "304cb2")
      self.backgroundColor = .white
      self.alpha = 1.0
    } else {
      icon.textColor = .white
      text.textColor = .white
      self.backgroundColor = .black
      self.alpha = 0.5
    }
  }
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
}