//
//  FocusableView.swift
//  TVOSShell
//
//  Created by Markim on 5/18/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class TopFeaturedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageView:UIImageView!
    var performAction:((Int) -> Void)?
    private var position:Int?
    
    func setup(pos:Int, image:UIImage?, action:((Int) -> Void)?) {
        self.performAction = action
        self.imageView.image = image
        self.position = pos
    }

    
    override func awakeFromNib() {
        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.adjustsImageWhenAncestorFocused = true
        self.clipsToBounds = false
        self.addSubview(self.imageView)

    }
    
    public override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
                
        guard   let action = self.performAction,
            let position = self.position
            else { return }
        
        if context.focusHeading == .right {
            action(position - 1)
        } else if context.focusHeading == .left {
            action(position + 1)
        }
        
        //This is behavior when the view has just lost focus
        if context.previouslyFocusedView == self {
            
            coordinator.addCoordinatedAnimations({
                self.backgroundColor = UIColor.red
            }, completion: nil)
        }
        
        //Behavior for when this view obtains focus
        if context.nextFocusedView == self {
            
        }
    }

}
