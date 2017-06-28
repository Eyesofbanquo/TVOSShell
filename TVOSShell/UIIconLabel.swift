//
//  UIIconLabel.swift
//  TVOSShell
//
//  Created by Markim on 6/9/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class UIIconLabel: UILabel {
  
  override var canBecomeFocused: Bool {
    return true
  }
  
  override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
    
    return true
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    super.didUpdateFocus(in: context, with: coordinator)
    
    ///Edit this to make the icons glow or something
    if context.nextFocusedView == self {
      self.textColor = UIColor.white
      self.alpha = 1.0
    } else {
      self.textColor = UIColor.white
      self.alpha = 0.5
    }

  }

}
