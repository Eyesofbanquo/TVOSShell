//
//  NDMainCollectionViewCell.swift
//  TVOSShell
//
//  Created by Markim on 6/7/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NDMainCollectionViewCell: UICollectionViewCell {
  
  override var canBecomeFocused: Bool {
    return true
  }
  
  //When this view is focused set the focus height to the focused value.
  private var focusedHeight: CGFloat = 554.0
  private var unfocusedHeight: CGFloat = 364.0
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if self == context.nextFocusedView {
      self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: focusedHeight)
    } else if self == context.previouslyFocusedView {
      self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: unfocusedHeight)
    }
  }
    
}
