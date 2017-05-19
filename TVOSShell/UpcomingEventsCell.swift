//
//  UpcomingEventsCell.swift
//  TVOSShell
//
//  Created by Markim on 5/12/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class UpcomingEventsCell: UICollectionViewCell {
    override var canBecomeFocused: Bool {
        return true
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if (self.isFocused) {
                self.layer.opacity = 0.0
            } else {
                self.layer.opacity = 1.0
            }
        }, completion: nil)
    }
}
