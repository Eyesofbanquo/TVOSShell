//
//  SearchCellCollectionViewCell.swift
//  TVOSShell
//
//  Created by Markim on 5/19/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class SearchCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var _cellImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard _cellImage != nil else { return }
        _cellImage.adjustsImageWhenAncestorFocused = true
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        //create changes to this item if it is current focused
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                self.backgroundColor = UIColor.red
                self.addParallaxMotionEffects(tiltValue: 0.25, panValue: 5.0)
            }, completion: nil)
        }
        //undo changes to the focused it
        if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                self.backgroundColor = UIColor.green
                self.motionEffects = []
            }, completion: nil)
        }

    }
}
