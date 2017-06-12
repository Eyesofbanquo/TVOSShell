//
//  NavigationBar.swift
//  TVOSShell
//
//  Created by Markim on 6/9/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NavigationStackView: UIStackView {
  override var canBecomeFocused: Bool {
    return true
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
  }
}

class NavigationBar: UIView {
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var favoritesButton: UIIconLabel!
  @IBOutlet weak var settingsButton: UIIconLabel!
  @IBOutlet weak var searchButton: UIIconLabel!
  
  var currentIcon: Int = 0
  var iconCount: Int = 3
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  override var canBecomeFocused: Bool {
    return true
  }
  
  /*override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [favoritesButton]
  }*/
  
  override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
    return true
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    super.didUpdateFocus(in: context, with: coordinator)
    var icons: [UILabel] = [favoritesButton, searchButton, settingsButton]
    if context.previouslyFocusedView is UICollectionViewCell {
    }
    
    if context.nextFocusedView is UICollectionViewCell {
      currentIcon = 0
    }
    
    icons[currentIcon].textColor = UIColor.black
    
    
    
    if context.focusHeading == .right {
      if currentIcon < icons.count {
        currentIcon = currentIcon + 1
      }
    }
    
    if context.focusHeading == .left {
      currentIcon != 0 ? currentIcon - 1 : currentIcon
    }
    
    if currentIcon >= 0 && currentIcon + 1 < icons.count {
      icons[currentIcon].textColor = UIColor.white
    }

  }
  
}
