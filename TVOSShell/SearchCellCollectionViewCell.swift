//
//  SearchCellCollectionViewCell.swift
//  TVOSShell
//
//  Created by Markim on 5/19/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class SearchCellCollectionViewCell: UICollectionViewCell {
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        //create changes to this item if it is current focused
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = UIColor.red

                })
            }, completion: nil)
        }
        //undo changes to the focused it
        if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.backgroundColor = UIColor.green
                })
            }, completion: nil)
        }
        if self.isFocused {
            
        }
    }
}
