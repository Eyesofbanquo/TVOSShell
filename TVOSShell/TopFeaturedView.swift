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
    @IBOutlet weak var title:UILabel!
    var featuredImageView:UIImageView!
    
    override func awakeFromNib() {
        self.clipsToBounds = false
        self.featuredImageView = UIImageView(frame: self.frame)
        self.addSubview(self.featuredImageView)
        self.sendSubview(toBack: self.featuredImageView)
        self.featuredImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.featuredImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.featuredImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.featuredImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    public override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        
        /* Add focus/unfocus behavior to the overall UIView so that you can tell when it was focused outside of just the moving text */
        
        //Behavior for when this view obtains focus
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                //self.backgroundColor = UIColor.green
                self.title.addParallaxMotionEffects(tiltValue: 0.0, panValue: 5.0)
                
                /* add a scale and shadow effect to the text */
                self.title.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                self.title.layer.shadowColor = UIColor.black.cgColor
                self.title.layer.shadowOffset = CGSize(width: -10, height: 10)
                self.title.layer.shadowOpacity = 0.2
                self.title.layer.shadowRadius = 5
            }, completion: nil)
            /* add effects to the title */
            
        }
        
        //This is behavior when the view has just lost focus
        if context.previouslyFocusedView == self {
            
            coordinator.addCoordinatedAnimations({
                //self.backgroundColor = UIColor.red
                self.title.motionEffects = []
                
                /* remove the scale and shadow effect from the text */
                self.title.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
                self.title.layer.shadowColor = UIColor.black.cgColor
                self.title.layer.shadowOffset = CGSize.zero
                self.title.layer.shadowOpacity = 0.0
                self.title.layer.shadowRadius = 0
            }, completion: nil)
        }
        
        
    }

}
