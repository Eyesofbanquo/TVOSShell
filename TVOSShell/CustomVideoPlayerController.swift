//
//  CustomVideoPlayerController.swift
//  TVOSShell
//
//  Created by Markim on 5/25/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class RandomView:UIView {
   /* override func draw(_ rect: CGRect) {
        super.
    }*/
    override var canBecomeFocused: Bool {
        return true
    }
}

class CustomVideoPlayerController: AVPlayerViewController {

    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(player:AVPlayer){
        super.init(nibName: "Main", bundle: nil)
        self.player = player
    }
    
    var bottomNavigationView:VideoBottomBarNavigation!
    var width:CGFloat!
    var height:CGFloat = 400.0
    var animator:UIViewPropertyAnimator!
    var bottomNavigationViewIsVisible:Bool!
    var visibleFrame:CGRect!
    var randomView:RandomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.bottomNavigationView = VideoBottomBarNavigation()
        
        /* Bring up the video bottom bar navigation */
        let swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.displayBottomNavigation(_:)))
        swipeUpGesture.direction = .up
        self.view.addGestureRecognizer(swipeUpGesture)
        
        self.bottomNavigationViewIsVisible = false
        
        //self.animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut, animations: nil)
        self.view.isUserInteractionEnabled = false
        self.view.resignFirstResponder()
        
        
    }
    
     override var preferredFocusEnvironments: [UIFocusEnvironment] {
        /*if self.bottomNavigationViewIsVisible {
            return [self.bottomNavigationView.collectionView]
        } else {
            return [self.view]
        }*/
        return [self.bottomNavigationView.collectionView]
        //return [self.randomView]

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.width = self.view.bounds.width
        
        
        /* This frame contains the position in which the bottom navigation bar should be visible */
        visibleFrame = CGRect(x: 0.0, y: self.view.frame.height - self.height, width: self.width, height: self.height)
        
        let swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.displayBottomNavigation(_:)))
        swipeDownGesture.direction = .down
        
        
        self.bottomNavigationView = VideoBottomBarNavigation(frame: CGRect(x: 0.0, y: self.view.bounds.height, width: self.width, height: self.height))
        swipeDownGesture.cancelsTouchesInView = true
        swipeDownGesture.delegate = self
        self.view.addGestureRecognizer(swipeDownGesture)
        
        self.bottomNavigationView.width = self.width
        self.bottomNavigationView.height = self.height
        self.bottomNavigationView.isUserInteractionEnabled = true
        
        self.view.addSubview(self.bottomNavigationView)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.count)
        //touches.first
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.count)
        
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            for i in item.gestureRecognizers! {
                if i is UISwipeGestureRecognizer {
                    
                }
            }
        }
    }
    
    func testGesture(_ sender:UISwipeGestureRecognizer){
        print("don")
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if self.bottomNavigationViewIsVisible {
            self.showsPlaybackControls = true
        }
        
        if context.previouslyFocusedView is UICollectionViewCell && !(context.nextFocusedView is UICollectionViewCell){
            print("going from collection view to the video player")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.replaceCurrentItem(with: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayBottomNavigation(_ sender: UISwipeGestureRecognizer) {

        if sender.direction == .down {
            if self.bottomNavigationView.frame == visibleFrame {
                self.animator.addAnimations {
                    self.bottomNavigationView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.width, height: self.height)
                }
                self.animator.addCompletion({
                    position in
                    self.setNeedsFocusUpdate()
                    self.updateFocusIfNeeded()
                })
                
                self.bottomNavigationViewIsVisible = false
                self.animator.startAnimation()
            }
        }
        if sender.direction == .up {
            /* this is to display the bottom navigation view and animate it into the screen */
            if bottomNavigationView.frame != visibleFrame{
                self.animator.addAnimations {
                    self.bottomNavigationView.frame = CGRect(x: 0.0, y: self.view.frame.height - self.bottomNavigationView.frame.height, width: self.bottomNavigationView.frame.width, height: self.bottomNavigationView.frame.height)
                }
                self.animator.addCompletion({
                    position in
                    self.setNeedsFocusUpdate()
                    self.updateFocusIfNeeded()
                    DispatchQueue.main.async {
                        //self.showsPlaybackControls = false
                        
                    }
                    DispatchQueue.main.async {
                        //self.showsPlaybackControls = false
                    }
                })
                self.bottomNavigationViewIsVisible = true
                self.animator.startAnimation()
            } else {
                if self.bottomNavigationView.frame == visibleFrame {
                    self.animator.addAnimations {
                        self.bottomNavigationView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.width, height: self.height)
                    }
                    self.animator.addCompletion({
                        position in
                        self.setNeedsFocusUpdate()
                        self.updateFocusIfNeeded()
                        
                    })
                    self.bottomNavigationViewIsVisible = false
                    self.animator.startAnimation()
                }
            }
        }
        
    }
}

extension CustomVideoPlayerController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
}
