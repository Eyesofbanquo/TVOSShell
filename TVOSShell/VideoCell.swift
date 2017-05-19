//
//  VideoCell.swift
//  TVOSShell
//
//  Created by Markim on 5/15/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var _videoImage:UIImageView!
    @IBOutlet weak var _videoTitle:UILabel!
    @IBOutlet weak var unfocusedConstraint:NSLayoutConstraint!

    
    var focusedConstraint:NSLayoutConstraint!
    
    override func awakeFromNib() {
        //Move the title text down once the imageView gains focus
        focusedConstraint = self._videoTitle.topAnchor.constraint(equalTo: self._videoImage.focusedFrameGuide.bottomAnchor, constant: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self._videoImage.image = nil
        //self._videoTitle.text = ""
        self.backgroundColor = UIColor.clear
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        /* If the cell doesn't have a value for the unfocusedConstraint then assign it a value */
        if self.unfocusedConstraint == nil {
            self.unfocusedConstraint = self._videoTitle.topAnchor.constraint(equalTo: self._videoImage.bottomAnchor, constant: 5)
        }
        self.focusedConstraint.isActive = self.isFocused
        self.unfocusedConstraint.isActive = !self.isFocused
        
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        setNeedsUpdateConstraints()
        
        if context.previouslyFocusedView == self && context.focusHeading == .left {
        }
        
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
