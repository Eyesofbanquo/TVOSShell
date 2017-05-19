//
//  FeaturedCollectionViewCell.swift
//  TVOSShell
//
//  Created by Markim on 5/10/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    //@IBOutlet weak var testView:UIView!
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.setNeedsFocusUpdate()

    }
    
    /* This function allows the UICollectionViewCell to give visual confirmation that the focus engine has shifted to it */
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.layer.opacity = 0.0
            } else {
                self.layer.opacity = 1.0
            }
        }, completion: nil)
    }
}
