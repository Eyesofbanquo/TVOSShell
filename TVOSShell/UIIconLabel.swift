//
//  UIIconLabel.swift
//  TVOSShell
//
//  Created by Markim on 6/9/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class UIIconLabel: UILabel {
  
  var glowLayer: CALayer!
  
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
      self.layer.shadowColor = self.textColor.cgColor
      self.layer.shadowRadius = 4.0
      self.layer.shadowOpacity = 0.9
      self.layer.shadowOffset = CGSize.zero
      self.layer.masksToBounds = false
      //self.layer.addSublayer(glowLayer)
      self.alpha = 1.0
    } else {
      self.textColor = UIColor.white
      self.layer.shadowOpacity = 0.0
      self.alpha = 0.5
    }

  }

}
